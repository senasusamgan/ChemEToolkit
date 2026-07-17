struct ProcessControlStrategyComparisonEngine: Sendable {
    func calculate(_ input: ProcessControlStrategyComparisonInput) throws -> ProcessControlStrategyComparisonResult {
        let values = [input.deadTimeToTimeConstantRatio, input.measurableDisturbanceFraction,
                      input.secondaryMeasurementQuality, input.processInteractionLevel,
                      input.processModelConfidence, input.operatingNonlinearity]
        guard values.allSatisfy(\.isFinite) else { throw ProcessControlStrategyComparisonError.nonFiniteInput }
        guard input.deadTimeToTimeConstantRatio >= 0 else {
            throw ProcessControlStrategyComparisonError.negativeDeadTimeRatio
        }
        let fractions = [input.measurableDisturbanceFraction, input.secondaryMeasurementQuality,
                         input.processInteractionLevel, input.processModelConfidence,
                         input.operatingNonlinearity]
        guard fractions.allSatisfy({ $0 >= 0 && $0 <= 1 }) else {
            throw ProcessControlStrategyComparisonError.fractionOutsideRange
        }

        let deadTime = min(1, input.deadTimeToTimeConstantRatio)
        func clamp(_ score: Double) -> Double { min(100, max(0, score)) }

        let pid = clamp(85 - 35 * deadTime - 25 * input.processInteractionLevel
                        - 20 * input.operatingNonlinearity + 10 * input.processModelConfidence)
        let feedforward = clamp(30 + 55 * input.measurableDisturbanceFraction
                                + 15 * input.processModelConfidence
                                - 15 * input.processInteractionLevel
                                - 10 * input.operatingNonlinearity)
        let cascade = clamp(35 + 50 * input.secondaryMeasurementQuality
                            - 20 * deadTime - 10 * input.processInteractionLevel
                            + 5 * input.processModelConfidence)
        let mpc = clamp(25 + 35 * input.processInteractionLevel
                        + 30 * input.processModelConfidence
                        + 20 * deadTime + 15 * input.operatingNonlinearity)

        let strategyNames: [String] = [
            "PID Feedback",
            "Feedforward + Feedback",
            "Cascade Control",
            "Model Predictive Control"
        ]

        let strategyScores: [Double] = [
            pid,
            feedforward,
            cascade,
            mpc
        ]

        let rankedIndices =
            strategyScores.indices.sorted { first, second in
                if strategyScores[first] == strategyScores[second] {
                    return strategyNames[first] < strategyNames[second]
                }

                return strategyScores[first] > strategyScores[second]
            }

        let bestIndex = rankedIndices[0]
        let secondIndex = rankedIndices[1]
        let bestName = strategyNames[bestIndex]
        let secondName = strategyNames[secondIndex]
        let separation = strategyScores[bestIndex] - strategyScores[secondIndex]
        let confidence = separation >= 20 ? "High score separation"
            : (separation >= 8 ? "Moderate score separation"
               : "Close alternatives; perform detailed dynamic studies")

        let reason: String
        switch bestName {
        case "PID Feedback":
            reason = "The process appears sufficiently simple, weakly interacting and not strongly delay dominated."
        case "Feedforward + Feedback":
            reason = "A large fraction of important disturbances is measurable before it affects the controlled output."
        case "Cascade Control":
            reason = "A useful secondary measurement is available for rejecting inner-loop disturbances quickly."
        default:
            reason = "Interaction, delay, nonlinearity or model-based coordination favor a multivariable predictive approach."
        }

        let scores = [pid, feedforward, cascade, mpc, separation]
        guard scores.allSatisfy({ $0.isFinite }), strategyScores.allSatisfy({ $0 >= 0 && $0 <= 100 }), separation >= 0 else {
            throw ProcessControlStrategyComparisonError.numericalFailure
        }

        return .init(
            pidScore: pid,
            feedforwardScore: feedforward,
            cascadeScore: cascade,
            mpcScore: mpc,
            recommendedStrategy: bestName,
            secondChoiceStrategy: secondName,
            recommendationReason: reason,
            scoreSeparation: separation,
            decisionConfidence: confidence,
            modelName: "Educational heuristic comparison of four process-control strategies",
            limitationDescription: "Scores are screening heuristics rather than universal design rules. Final selection requires dynamic models, safety analysis, economics, instrumentation review, constraint assessment and plant testing."
        )
    }
}
