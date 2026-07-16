struct StepResponseRTDAnalysisEngine:
    Sendable {

    private let rangeTolerance =
        1.0e-12

    func calculate(
        _ input:
            StepResponseRTDAnalysisInput
    ) throws
        -> StepResponseRTDAnalysisResult {

        guard
            input.times.count
            == input.normalizedOutletResponses.count
        else {
            throw StepResponseRTDAnalysisError
                .mismatchedArrays
        }

        guard input.times.count >= 2 else {
            throw StepResponseRTDAnalysisError
                .insufficientData
        }

        guard
            input.times.allSatisfy(\.isFinite),
            input.normalizedOutletResponses
                .allSatisfy(\.isFinite)
        else {
            throw StepResponseRTDAnalysisError
                .nonFiniteInput
        }

        guard
            input.times
                .allSatisfy({
                    $0 >= 0
                })
        else {
            throw StepResponseRTDAnalysisError
                .negativeTime
        }

        guard
            zip(
                input.times,
                input.times.dropFirst()
            )
            .allSatisfy({
                $0 < $1
            })
        else {
            throw StepResponseRTDAnalysisError
                .nonIncreasingTime
        }

        guard
            input.normalizedOutletResponses
                .allSatisfy({
                    $0 >= -rangeTolerance
                    && $0 <= 1
                        + rangeTolerance
                })
        else {
            throw StepResponseRTDAnalysisError
                .responseOutOfRange
        }

        guard
            zip(
                input.normalizedOutletResponses,
                input.normalizedOutletResponses
                    .dropFirst()
            )
            .allSatisfy({
                $0 <= $1
                    + rangeTolerance
            })
        else {
            throw StepResponseRTDAnalysisError
                .nonMonotonicResponse
        }

        let finalResponse =
            input.normalizedOutletResponses.last!

        guard finalResponse >= 0.95 else {
            throw StepResponseRTDAnalysisError
                .incompleteResponse
        }

        let normalizedF =
            input.normalizedOutletResponses
                .map {
                    min(
                        1,
                        max(0, $0)
                    )
                }

        var meanResidenceTime = 0.0
        var intervalEValues: [Double] = []
        var midpointTimes: [Double] = []

        for index in 0..<(input.times.count - 1) {
            let timeStep =
                input.times[index + 1]
                - input.times[index]

            let lowerSurvival =
                1 - normalizedF[index]

            let upperSurvival =
                1 - normalizedF[index + 1]

            meanResidenceTime +=
                0.5
                * (
                    lowerSurvival
                    + upperSurvival
                )
                * timeStep

            intervalEValues.append(
                (
                    normalizedF[index + 1]
                    - normalizedF[index]
                )
                / timeStep
            )

            midpointTimes.append(
                0.5
                * (
                    input.times[index]
                    + input.times[index + 1]
                )
            )
        }

        func quantileTime(
            target: Double
        ) throws -> Double {
            if normalizedF[0] >= target {
                return input.times[0]
            }

            for index in 1..<normalizedF.count {
                if normalizedF[index] >= target {
                    let lowerF =
                        normalizedF[index - 1]

                    let upperF =
                        normalizedF[index]

                    let fChange =
                        upperF - lowerF

                    if fChange <= 0 {
                        return input.times[index]
                    }

                    let fraction =
                        (
                            target - lowerF
                        )
                        / fChange

                    return input.times[index - 1]
                    + fraction
                    * (
                        input.times[index]
                        - input.times[index - 1]
                    )
                }
            }

            throw StepResponseRTDAnalysisError
                .medianNotResolved
        }

        let median =
            try quantileTime(
                target: 0.5
            )

        let immediateBypass =
            normalizedF[0]

        let completeness =
            finalResponse

        let scalarResults = [
            meanResidenceTime,
            median,
            immediateBypass,
            finalResponse,
            completeness
        ]

        guard
            scalarResults
                .allSatisfy(\.isFinite),
            intervalEValues
                .allSatisfy(\.isFinite),
            midpointTimes
                .allSatisfy(\.isFinite),
            meanResidenceTime >= 0,
            median >= 0,
            immediateBypass >= 0,
            immediateBypass <= 1
        else {
            throw StepResponseRTDAnalysisError
                .numericalFailure
        }

        return .init(
            normalizedFValues:
                normalizedF,
            intervalEValues:
                intervalEValues,
            intervalMidpointTimes:
                midpointTimes,
            meanResidenceTime:
                meanResidenceTime,
            medianResidenceTime:
                median,
            immediateBypassFraction:
                immediateBypass,
            finalResponse:
                finalResponse,
            responseCompleteness:
                completeness,
            modelName:
                "Step-tracer RTD analysis using F(t) = C_out(t)/C_in and t̄ = ∫[1−F(t)]dt",
            limitationDescription:
                "The finite observation window must capture at least 95% of the final step response. Interval E values are finite-difference averages, not pointwise derivatives."
        )
    }
}
