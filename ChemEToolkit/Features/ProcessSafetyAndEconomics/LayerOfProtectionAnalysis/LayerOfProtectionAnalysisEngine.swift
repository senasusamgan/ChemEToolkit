struct LayerOfProtectionAnalysisEngine:
    Sendable {

    func calculate(
        _ input:
            LayerOfProtectionAnalysisInput
    ) throws
        -> LayerOfProtectionAnalysisResult {

        let values = [
            input.initiatingEventFrequency,
            input.enablingConditionProbability,
            input.conditionalModifierProbability,
            input.protectionLayer1PFD,
            input.protectionLayer2PFD,
            input.protectionLayer3PFD,
            input.tolerableEventFrequency
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LayerOfProtectionAnalysisError
                .nonFiniteInput
        }

        guard
            input.initiatingEventFrequency > 0
        else {
            throw LayerOfProtectionAnalysisError
                .nonPositiveInitiatingFrequency
        }

        let probabilities = [
            input.enablingConditionProbability,
            input.conditionalModifierProbability,
            input.protectionLayer1PFD,
            input.protectionLayer2PFD,
            input.protectionLayer3PFD
        ]

        guard
            probabilities.allSatisfy({
                $0 > 0 && $0 <= 1
            })
        else {
            throw LayerOfProtectionAnalysisError
                .probabilityOutsideRange
        }

        guard input.tolerableEventFrequency > 0 else {
            throw LayerOfProtectionAnalysisError
                .nonPositiveTolerableFrequency
        }

        let unmitigatedFrequency =
            input.initiatingEventFrequency
            * input.enablingConditionProbability
            * input.conditionalModifierProbability

        let combinedPFD =
            input.protectionLayer1PFD
            * input.protectionLayer2PFD
            * input.protectionLayer3PFD

        let mitigatedFrequency =
            unmitigatedFrequency
            * combinedPFD

        let achievedRRF =
            1 / combinedPFD

        let frequencyRatio =
            mitigatedFrequency
            / input.tolerableEventFrequency

        let comparisonTolerance =
            max(
                1e-15,
                input.tolerableEventFrequency
                * 1e-12
            )

        let targetMet =
            mitigatedFrequency
            <= input.tolerableEventFrequency
                + comparisonTolerance

        let additionalRRF =
            targetMet
            ? 1
            : max(
                1,
                frequencyRatio
            )

        let activeLayerCount =
            [
                input.protectionLayer1PFD,
                input.protectionLayer2PFD,
                input.protectionLayer3PFD
            ]
            .filter {
                $0 < 1
            }
            .count

        let assessment =
            targetMet
            ? "The screening frequency is at or below the entered tolerable frequency."
            : "Additional independent risk reduction is required to reach the entered tolerable frequency."

        let results = [
            unmitigatedFrequency,
            combinedPFD,
            mitigatedFrequency,
            achievedRRF,
            additionalRRF
        ]

        guard
            results.allSatisfy(\.isFinite),
            unmitigatedFrequency > 0,
            combinedPFD > 0,
            combinedPFD <= 1,
            mitigatedFrequency > 0,
            achievedRRF >= 1,
            additionalRRF >= 1
        else {
            throw LayerOfProtectionAnalysisError
                .numericalFailure
        }

        return .init(
            unmitigatedScenarioFrequency:
                unmitigatedFrequency,
            combinedProtectionLayerPFD:
                combinedPFD,
            mitigatedScenarioFrequency:
                mitigatedFrequency,
            achievedRiskReductionFactor:
                achievedRRF,
            requiredAdditionalRiskReductionFactor:
                additionalRRF,
            targetIsMet:
                targetMet,
            activeProtectionLayerCount:
                activeLayerCount,
            assessmentDescription:
                assessment,
            modelName:
                "Multiplicative Layer of Protection Analysis screening model",
            limitationDescription:
                "Only credit protection layers that are effective, independent, auditable and maintained. Common-cause failure, human dependency, uncertainty and consequence severity require a formal facilitated LOPA."
        )
    }
}
