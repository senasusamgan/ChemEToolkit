struct FCurveGeneratorEngine:
    Sendable {

    func calculate(
        _ input:
            FCurveGeneratorInput
    ) throws
        -> FCurveGeneratorResult {

        guard
            input.times.count
            == input.eValues.count
        else {
            throw FCurveGeneratorError
                .mismatchedArrays
        }

        guard input.times.count >= 2 else {
            throw FCurveGeneratorError
                .insufficientData
        }

        guard
            input.times.allSatisfy(\.isFinite),
            input.eValues
                .allSatisfy(\.isFinite)
        else {
            throw FCurveGeneratorError
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
            throw FCurveGeneratorError
                .nonIncreasingTime
        }

        guard
            input.eValues
                .allSatisfy({
                    $0 >= 0
                })
        else {
            throw FCurveGeneratorError
                .negativeEValue
        }

        var rawArea = 0.0

        for index in 0..<(input.times.count - 1) {
            rawArea +=
                0.5
                * (
                    input.eValues[index]
                    + input.eValues[index + 1]
                )
                * (
                    input.times[index + 1]
                    - input.times[index]
                )
        }

        guard rawArea > 0 else {
            throw FCurveGeneratorError
                .zeroEArea
        }

        let normalizedE =
            input.eValues.map {
                $0 / rawArea
            }

        var cumulative =
            Array(
                repeating: 0.0,
                count: input.times.count
            )

        for index in 0..<(input.times.count - 1) {
            let increment =
                0.5
                * (
                    normalizedE[index]
                    + normalizedE[index + 1]
                )
                * (
                    input.times[index + 1]
                    - input.times[index]
                )

            cumulative[index + 1] =
                cumulative[index]
                + increment
        }

        cumulative[
            cumulative.count - 1
        ] = 1

        func time(
            at cumulativeTarget: Double
        ) throws -> Double {
            for index in 1..<cumulative.count {
                if cumulative[index]
                    >= cumulativeTarget {

                    let lowerF =
                        cumulative[index - 1]

                    let upperF =
                        cumulative[index]

                    let lowerTime =
                        input.times[index - 1]

                    let upperTime =
                        input.times[index]

                    let fChange =
                        upperF - lowerF

                    if fChange <= 0 {
                        return upperTime
                    }

                    let fraction =
                        (
                            cumulativeTarget
                            - lowerF
                        )
                        / fChange

                    return lowerTime
                    + fraction
                    * (
                        upperTime
                        - lowerTime
                    )
                }
            }

            throw FCurveGeneratorError
                .quantileNotResolved
        }

        let timeTen =
            try time(
                at: 0.10
            )

        let timeFifty =
            try time(
                at: 0.50
            )

        let timeNinety =
            try time(
                at: 0.90
            )

        let span =
            timeNinety
            - timeTen

        let scalarResults = [
            rawArea,
            timeTen,
            timeFifty,
            timeNinety,
            span
        ]

        guard
            scalarResults
                .allSatisfy(\.isFinite),
            normalizedE
                .allSatisfy(\.isFinite),
            cumulative
                .allSatisfy(\.isFinite),
            timeTen <= timeFifty,
            timeFifty <= timeNinety,
            span >= 0
        else {
            throw FCurveGeneratorError
                .numericalFailure
        }

        return .init(
            rawEArea:
                rawArea,
            normalizedEValues:
                normalizedE,
            fValues:
                cumulative,
            timeAtTenPercent:
                timeTen,
            medianResidenceTime:
                timeFifty,
            timeAtNinetyPercent:
                timeNinety,
            centralEightyPercentSpan:
                span,
            modelName:
                "Cumulative F-curve generated by trapezoidal integration of E(t)",
            limitationDescription:
                "Quantiles are linearly interpolated between measured points. Sparse sampling or an incomplete tracer tail can shift t10, t50 and t90."
        )
    }
}
