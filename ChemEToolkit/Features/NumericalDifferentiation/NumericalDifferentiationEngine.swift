import Foundation

struct NumericalDifferentiationEngine {
    private let comparisonTolerance = 1e-12

    func differentiate(
        method: NumericalDifferentiationMethod,
        input: NumericalDifferentiationInput
    ) throws -> NumericalDifferentiationResult {
        try validateInput(
            method: method,
            input: input
        )

        let sortedPoints = input.points.sorted {
            $0.x < $1.x
        }

        guard let targetIndex =
                sortedPoints.firstIndex(
                    where: {
                        approximatelyEqual(
                            $0.x,
                            input.targetX
                        )
                    }
                )
        else {
            throw CalculationError.calculationFailed(
                reason:
                    "Target x must match one of the entered data points."
            )
        }

        let calculation =
            try calculateDerivative(
                method: method,
                points: sortedPoints,
                targetIndex: targetIndex
            )

        let spacingInformation =
            spacingInformation(
                for: calculation.usedPoints
            )

        return NumericalDifferentiationResult(
            method: method,
            targetX:
                sortedPoints[targetIndex].x,
            derivative:
                try InputValidator.validateResult(
                    calculation.derivative
                ),
            pointCount: sortedPoints.count,
            usedPoints:
                calculation.usedPoints,
            lowerBound:
                sortedPoints.first?.x ??
                input.targetX,
            upperBound:
                sortedPoints.last?.x ??
                input.targetX,
            isEquallySpaced:
                spacingInformation.isEquallySpaced,
            spacing:
                spacingInformation.spacing
        )
    }

    private func validateInput(
        method: NumericalDifferentiationMethod,
        input: NumericalDifferentiationInput
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
        _ points: [DifferentiationPoint]
    ) throws {
        guard points.count >= 2 else {
            return
        }

        let sortedPoints = points.sorted {
            $0.x < $1.x
        }

        for index in
            0..<(sortedPoints.count - 1) {

            let firstX =
                sortedPoints[index].x

            let secondX =
                sortedPoints[index + 1].x

            guard !approximatelyEqual(
                firstX,
                secondX
            ) else {
                throw CalculationError
                    .calculationFailed(
                        reason:
                            "Each data point must have a unique x value."
                    )
            }
        }
    }

    private func calculateDerivative(
        method: NumericalDifferentiationMethod,
        points: [DifferentiationPoint],
        targetIndex: Int
    ) throws -> DerivativeCalculation {
        switch method {
        case .forward:
            return try forwardDifference(
                points: points,
                targetIndex: targetIndex
            )

        case .backward:
            return try backwardDifference(
                points: points,
                targetIndex: targetIndex
            )

        case .central:
            return try centralDifference(
                points: points,
                targetIndex: targetIndex
            )
        }
    }

    private func forwardDifference(
        points: [DifferentiationPoint],
        targetIndex: Int
    ) throws -> DerivativeCalculation {
        guard targetIndex <
                points.count - 1 else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "Forward Difference requires a data point after the target x value."
                )
        }

        let currentPoint =
            points[targetIndex]

        let nextPoint =
            points[targetIndex + 1]

        let denominator =
            nextPoint.x -
            currentPoint.x

        guard denominator != 0 else {
            throw CalculationError.divisionByZero
        }

        let derivative =
            (
                nextPoint.y -
                currentPoint.y
            ) / denominator

        return DerivativeCalculation(
            derivative: derivative,
            usedPoints: [
                currentPoint,
                nextPoint
            ]
        )
    }

    private func backwardDifference(
        points: [DifferentiationPoint],
        targetIndex: Int
    ) throws -> DerivativeCalculation {
        guard targetIndex > 0 else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "Backward Difference requires a data point before the target x value."
                )
        }

        let previousPoint =
            points[targetIndex - 1]

        let currentPoint =
            points[targetIndex]

        let denominator =
            currentPoint.x -
            previousPoint.x

        guard denominator != 0 else {
            throw CalculationError.divisionByZero
        }

        let derivative =
            (
                currentPoint.y -
                previousPoint.y
            ) / denominator

        return DerivativeCalculation(
            derivative: derivative,
            usedPoints: [
                previousPoint,
                currentPoint
            ]
        )
    }

    private func centralDifference(
        points: [DifferentiationPoint],
        targetIndex: Int
    ) throws -> DerivativeCalculation {
        guard
            targetIndex > 0,
            targetIndex < points.count - 1
        else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "Central Difference requires data points on both sides of the target x value."
                )
        }

        let previousPoint =
            points[targetIndex - 1]

        let targetPoint =
            points[targetIndex]

        let nextPoint =
            points[targetIndex + 1]

        let x0 = previousPoint.x
        let x1 = targetPoint.x
        let x2 = nextPoint.x

        let firstCoefficient =
            (x1 - x2) /
            (
                (x0 - x1) *
                (x0 - x2)
            )

        let secondCoefficient =
            (
                2 * x1 -
                x0 -
                x2
            ) /
            (
                (x1 - x0) *
                (x1 - x2)
            )

        let thirdCoefficient =
            (x1 - x0) /
            (
                (x2 - x0) *
                (x2 - x1)
            )

        let derivative =
            previousPoint.y *
                firstCoefficient +
            targetPoint.y *
                secondCoefficient +
            nextPoint.y *
                thirdCoefficient

        return DerivativeCalculation(
            derivative: derivative,
            usedPoints: [
                previousPoint,
                targetPoint,
                nextPoint
            ]
        )
    }

    private func spacingInformation(
        for points: [DifferentiationPoint]
    ) -> SpacingInformation {
        guard points.count >= 2 else {
            return SpacingInformation(
                isEquallySpaced: false,
                spacing: nil
            )
        }

        let firstSpacing =
            points[1].x -
            points[0].x

        guard points.count >= 3 else {
            return SpacingInformation(
                isEquallySpaced: true,
                spacing: firstSpacing
            )
        }

        let secondSpacing =
            points[2].x -
            points[1].x

        let scale = max(
            1,
            max(
                abs(firstSpacing),
                abs(secondSpacing)
            )
        )

        let isEquallySpaced =
            abs(
                firstSpacing -
                secondSpacing
            ) <=
            comparisonTolerance *
            scale

        return SpacingInformation(
            isEquallySpaced:
                isEquallySpaced,
            spacing:
                isEquallySpaced
                ? firstSpacing
                : nil
        )
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
            firstValue -
            secondValue
        ) <=
        comparisonTolerance *
        scale
    }
}

private struct DerivativeCalculation {
    let derivative: Double
    let usedPoints: [DifferentiationPoint]
}

private struct SpacingInformation {
    let isEquallySpaced: Bool
    let spacing: Double?
}
