struct ECurveGeneratorEngine:
    Sendable {

    func calculate(
        _ input:
            ECurveGeneratorInput
    ) throws
        -> ECurveGeneratorResult {

        guard
            input.times.count
            == input.tracerConcentrations.count
        else {
            throw ECurveGeneratorError
                .mismatchedArrays
        }

        guard input.times.count >= 2 else {
            throw ECurveGeneratorError
                .insufficientData
        }

        guard
            input.times.allSatisfy(\.isFinite),
            input.tracerConcentrations
                .allSatisfy(\.isFinite)
        else {
            throw ECurveGeneratorError
                .nonFiniteInput
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
            throw ECurveGeneratorError
                .nonIncreasingTime
        }

        guard
            input.tracerConcentrations
                .allSatisfy({
                    $0 >= 0
                })
        else {
            throw ECurveGeneratorError
                .negativeConcentration
        }

        func integrate(
            _ values: [Double]
        ) -> Double {
            var total = 0.0

            for index in 0..<(input.times.count - 1) {
                let timeStep =
                    input.times[index + 1]
                    - input.times[index]

                total +=
                    0.5
                    * (
                        values[index]
                        + values[index + 1]
                    )
                    * timeStep
            }

            return total
        }

        let rawArea =
            integrate(
                input.tracerConcentrations
            )

        guard rawArea > 0 else {
            throw ECurveGeneratorError
                .zeroTracerArea
        }

        let eValues =
            input.tracerConcentrations
                .map {
                    $0 / rawArea
                }

        let normalizedArea =
            integrate(eValues)

        let firstMomentValues =
            zip(
                input.times,
                eValues
            )
            .map(*)

        let meanResidenceTime =
            integrate(
                firstMomentValues
            )

        guard meanResidenceTime > 0 else {
            throw ECurveGeneratorError
                .nonPositiveMeanResidenceTime
        }

        let dimensionlessTimes =
            input.times.map {
                $0 / meanResidenceTime
            }

        guard
            let peakIndex =
                eValues.indices.max(
                    by: {
                        eValues[$0]
                        < eValues[$1]
                    }
                )
        else {
            throw ECurveGeneratorError
                .numericalFailure
        }

        let peakTime =
            input.times[peakIndex]

        let peakEValue =
            eValues[peakIndex]

        let scalarResults = [
            rawArea,
            normalizedArea,
            meanResidenceTime,
            peakTime,
            peakEValue
        ]

        guard
            scalarResults
                .allSatisfy(\.isFinite),
            eValues.allSatisfy(\.isFinite),
            dimensionlessTimes
                .allSatisfy(\.isFinite),
            normalizedArea > 0,
            peakEValue >= 0
        else {
            throw ECurveGeneratorError
                .numericalFailure
        }

        return .init(
            rawTracerArea:
                rawArea,
            normalizedArea:
                normalizedArea,
            eValues:
                eValues,
            dimensionlessTimes:
                dimensionlessTimes,
            meanResidenceTime:
                meanResidenceTime,
            peakTime:
                peakTime,
            peakEValue:
                peakEValue,
            modelName:
                "Pulse-tracer E-curve normalization with trapezoidal integration",
            limitationDescription:
                "The measured time window must capture the complete tracer response. Missing early or late tracer mass biases normalization and the calculated mean residence time."
        )
    }
}
