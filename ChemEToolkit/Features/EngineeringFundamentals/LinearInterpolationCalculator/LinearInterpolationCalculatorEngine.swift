struct LinearInterpolationCalculatorEngine:
    Sendable {

    func calculate(
        _ input:
            LinearInterpolationCalculatorInput
    ) throws
        -> LinearInterpolationCalculatorResult {

        let values = [
            input.x1,
            input.y1,
            input.x2,
            input.y2,
            input.targetX
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LinearInterpolationCalculatorError
                .nonFiniteInput
        }

        guard input.x1 != input.x2 else {
            throw LinearInterpolationCalculatorError
                .identicalXValues
        }

        let fraction =
            (
                input.targetX
                - input.x1
            )
            / (
                input.x2
                - input.x1
            )

        let slope =
            (
                input.y2
                - input.y1
            )
            / (
                input.x2
                - input.x1
            )

        let interpolatedY =
            input.y1
            + fraction
            * (
                input.y2
                - input.y1
            )

        let lowerX =
            min(
                input.x1,
                input.x2
            )

        let upperX =
            max(
                input.x1,
                input.x2
            )

        let extrapolation =
            input.targetX < lowerX
            || input.targetX > upperX

        let description =
            extrapolation
            ? "Target x lies outside the known interval, so this is linear extrapolation."
            : "Target x lies inside the known interval, so this is linear interpolation."

        let results = [
            fraction,
            slope,
            interpolatedY
        ]

        guard results.allSatisfy(\.isFinite) else {
            throw LinearInterpolationCalculatorError
                .numericalFailure
        }

        return .init(
            interpolatedY:
                interpolatedY,
            interpolationFraction:
                fraction,
            slope:
                slope,
            isExtrapolation:
                extrapolation,
            rangeDescription:
                description,
            modelName:
                "Two-point linear interpolation",
            limitationDescription:
                "Accuracy depends on the property varying approximately linearly between the two known points."
        )
    }
}
