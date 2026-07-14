import Foundation

struct NumericalIntegrationEngine {
    private let spacingTolerance = 1e-9

    func integrate(
        method: NumericalIntegrationMethod,
        input: NumericalIntegrationInput
    ) throws -> NumericalIntegrationResult {
        let points = input.points

        try validatePointCount(
            points,
            method: method
        )

        try validateFiniteValues(points)
        try validateIncreasingXValues(points)

        let spacingInformation =
            spacingInformation(for: points)

        let integral: Double

        switch method {
        case .trapezoidal:
            integral = trapezoidalIntegral(
                points: points
            )

        case .simpsonOneThird:
            integral = try simpsonIntegral(
                points: points,
                spacingInformation:
                    spacingInformation
            )
        }

        return NumericalIntegrationResult(
            method: method,
            value:
                try InputValidator.validateResult(
                    integral
                ),
            pointCount: points.count,
            intervalCount: points.count - 1,
            lowerBound: points[0].x,
            upperBound: points[points.count - 1].x,
            isEquallySpaced:
                spacingInformation.isEquallySpaced,
            spacing:
                spacingInformation.spacing
        )
    }

    private func validatePointCount(
        _ points: [IntegrationPoint],
        method: NumericalIntegrationMethod
    ) throws {
        guard points.count >=
                method.minimumPointCount else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "At least \(method.minimumPointCount) data points are required for the \(method.title)."
                )
        }
    }

    private func validateFiniteValues(
        _ points: [IntegrationPoint]
    ) throws {
        let allValuesAreFinite =
            points.allSatisfy {
                $0.x.isFinite &&
                $0.y.isFinite
            }

        guard allValuesAreFinite else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "All x and f(x) values must be finite numbers."
                )
        }
    }

    private func validateIncreasingXValues(
        _ points: [IntegrationPoint]
    ) throws {
        for index in 0..<(points.count - 1) {
            guard points[index + 1].x >
                    points[index].x else {
                throw CalculationError
                    .calculationFailed(
                        reason:
                            "x values must be entered in strictly increasing order."
                    )
            }
        }
    }

    private func trapezoidalIntegral(
        points: [IntegrationPoint]
    ) -> Double {
        var integral = 0.0

        for index in 0..<(points.count - 1) {
            let currentPoint =
                points[index]

            let nextPoint =
                points[index + 1]

            let intervalWidth =
                nextPoint.x -
                currentPoint.x

            let averageHeight =
                (
                    currentPoint.y +
                    nextPoint.y
                ) / 2

            integral +=
                intervalWidth *
                averageHeight
        }

        return integral
    }

    private func simpsonIntegral(
        points: [IntegrationPoint],
        spacingInformation:
            SpacingInformation
    ) throws -> Double {
        let intervalCount =
            points.count - 1

        guard intervalCount.isMultiple(
            of: 2
        ) else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "Simpson’s 1/3 Rule requires an even number of subintervals."
                )
        }

        guard
            spacingInformation
                .isEquallySpaced,
            let spacing =
                spacingInformation.spacing
        else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "Simpson’s 1/3 Rule requires equally spaced x values."
                )
        }

        var weightedSum =
            points[0].y +
            points[points.count - 1].y

        for index in 1..<(points.count - 1) {
            let multiplier =
                index.isMultiple(of: 2)
                ? 2.0
                : 4.0

            weightedSum +=
                multiplier *
                points[index].y
        }

        return spacing /
            3 *
            weightedSum
    }

    private func spacingInformation(
        for points: [IntegrationPoint]
    ) -> SpacingInformation {
        guard points.count >= 2 else {
            return SpacingInformation(
                isEquallySpaced: false,
                spacing: nil
            )
        }

        let referenceSpacing =
            points[1].x -
            points[0].x

        let allowedDifference =
            spacingTolerance *
            max(
                1,
                abs(referenceSpacing)
            )

        for index in 1..<(points.count - 1) {
            let currentSpacing =
                points[index + 1].x -
                points[index].x

            guard abs(
                currentSpacing -
                referenceSpacing
            ) <= allowedDifference else {
                return SpacingInformation(
                    isEquallySpaced: false,
                    spacing: nil
                )
            }
        }

        return SpacingInformation(
            isEquallySpaced: true,
            spacing: referenceSpacing
        )
    }
}

private struct SpacingInformation {
    let isEquallySpaced: Bool
    let spacing: Double?
}
