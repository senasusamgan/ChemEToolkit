import Foundation

struct NumericalInterpolationEngine {
    private let duplicateTolerance = 1e-12

    func interpolate(
        method: NumericalInterpolationMethod,
        input: NumericalInterpolationInput
    ) throws -> NumericalInterpolationResult {
        try validateInput(
            method: method,
            input: input
        )

        let sortedPoints = input.points.sorted {
            $0.x < $1.x
        }

        let resultValue: Double

        switch method {
        case .linear:
            resultValue = try linearInterpolation(
                points: sortedPoints,
                targetX: input.targetX
            )

        case .lagrange:
            resultValue = try lagrangeInterpolation(
                points: sortedPoints,
                targetX: input.targetX
            )
        }

        let lowerBound =
            sortedPoints.first?.x ?? input.targetX

        let upperBound =
            sortedPoints.last?.x ?? input.targetX

        return NumericalInterpolationResult(
            method: method,
            targetX: input.targetX,
            interpolatedY:
                try InputValidator.validateResult(
                    resultValue
                ),
            pointCount: sortedPoints.count,
            lowerBound: lowerBound,
            upperBound: upperBound,
            isExtrapolation:
                input.targetX < lowerBound ||
                input.targetX > upperBound,
            polynomialDegree:
                method == .linear
                ? 1
                : sortedPoints.count - 1
        )
    }

    private func validateInput(
        method: NumericalInterpolationMethod,
        input: NumericalInterpolationInput
    ) throws {
        guard input.targetX.isFinite else {
            throw CalculationError.invalidNumber(
                fieldName: "Target x"
            )
        }

        guard input.points.count >=
                method.minimumPointCount else {
            throw CalculationError.calculationFailed(
                reason:
                    "At least \(method.minimumPointCount) data points are required for \(method.title)."
            )
        }

        if let requiredPointCount =
            method.requiredPointCount {
            guard input.points.count ==
                    requiredPointCount else {
                throw CalculationError.calculationFailed(
                    reason:
                        "\(method.title) requires exactly \(requiredPointCount) data points."
                )
            }
        }

        let allValuesAreFinite =
            input.points.allSatisfy {
                $0.x.isFinite &&
                $0.y.isFinite
            }

        guard allValuesAreFinite else {
            throw CalculationError.calculationFailed(
                reason:
                    "All x and f(x) values must be finite numbers."
            )
        }

        try validateUniqueXValues(
            input.points
        )
    }

    private func validateUniqueXValues(
        _ points: [InterpolationPoint]
    ) throws {
        guard points.count >= 2 else {
            return
        }

        for firstIndex in
            0..<(points.count - 1) {

            for secondIndex in
                (firstIndex + 1)..<points.count {

                let firstX =
                    points[firstIndex].x

                let secondX =
                    points[secondIndex].x

                let scale = max(
                    1,
                    max(
                        abs(firstX),
                        abs(secondX)
                    )
                )

                let difference =
                    abs(firstX - secondX)

                guard difference >
                        duplicateTolerance * scale
                else {
                    throw CalculationError
                        .calculationFailed(
                            reason:
                                "Each data point must have a unique x value."
                        )
                }
            }
        }
    }

    private func linearInterpolation(
        points: [InterpolationPoint],
        targetX: Double
    ) throws -> Double {
        guard points.count == 2 else {
            throw CalculationError.calculationFailed(
                reason:
                    "Linear Interpolation requires exactly 2 data points."
            )
        }

        let firstPoint = points[0]
        let secondPoint = points[1]

        let denominator =
            secondPoint.x - firstPoint.x

        guard denominator != 0 else {
            throw CalculationError.divisionByZero
        }

        return firstPoint.y +
            (
                targetX - firstPoint.x
            ) *
            (
                secondPoint.y -
                firstPoint.y
            ) /
            denominator
    }

    private func lagrangeInterpolation(
        points: [InterpolationPoint],
        targetX: Double
    ) throws -> Double {
        if let exactPoint = points.first(
            where: {
                approximatelyEqual(
                    $0.x,
                    targetX
                )
            }
        ) {
            return exactPoint.y
        }

        var interpolatedValue = 0.0

        for currentIndex in points.indices {
            var basisPolynomial = 1.0

            for otherIndex in points.indices
            where otherIndex != currentIndex {
                let numerator =
                    targetX -
                    points[otherIndex].x

                let denominator =
                    points[currentIndex].x -
                    points[otherIndex].x

                guard denominator != 0 else {
                    throw CalculationError
                        .divisionByZero
                }

                basisPolynomial *=
                    numerator / denominator
            }

            interpolatedValue +=
                points[currentIndex].y *
                basisPolynomial
        }

        return interpolatedValue
    }

    private func approximatelyEqual(
        _ firstValue: Double,
        _ secondValue: Double
    ) -> Bool {
        let scale = max(
            1,
            max(
                abs(firstValue),
                abs(secondValue)
            )
        )

        return abs(
            firstValue - secondValue
        ) <= duplicateTolerance * scale
    }
}
