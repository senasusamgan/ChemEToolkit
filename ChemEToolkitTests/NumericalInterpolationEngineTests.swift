import Testing
@testable import ChemEToolkit

@Suite("Numerical Interpolation Engine")
struct NumericalInterpolationEngineTests {
    private let engine =
        NumericalInterpolationEngine()

    private let tolerance =
        0.00000001

    @Test("Calculates linear interpolation")
    func calculatesLinearInterpolation()
        throws {

        let input =
            NumericalInterpolationInput(
                points: [
                    InterpolationPoint(
                        x: 0,
                        y: 0
                    ),
                    InterpolationPoint(
                        x: 10,
                        y: 20
                    )
                ],
                targetX: 5
            )

        let result =
            try engine.interpolate(
                method: .linear,
                input: input
            )

        #expect(
            abs(
                result.interpolatedY - 10
            ) < tolerance
        )

        #expect(result.pointCount == 2)
        #expect(result.polynomialDegree == 1)
        #expect(result.isExtrapolation == false)
    }

    @Test("Detects linear extrapolation")
    func detectsLinearExtrapolation()
        throws {

        let input =
            NumericalInterpolationInput(
                points: [
                    InterpolationPoint(
                        x: 0,
                        y: 0
                    ),
                    InterpolationPoint(
                        x: 10,
                        y: 20
                    )
                ],
                targetX: 15
            )

        let result =
            try engine.interpolate(
                method: .linear,
                input: input
            )

        #expect(
            abs(
                result.interpolatedY - 30
            ) < tolerance
        )

        #expect(result.isExtrapolation)
    }

    @Test("Calculates Lagrange interpolation")
    func calculatesLagrangeInterpolation()
        throws {

        let input =
            NumericalInterpolationInput(
                points: [
                    InterpolationPoint(
                        x: 0,
                        y: 0
                    ),
                    InterpolationPoint(
                        x: 1,
                        y: 1
                    ),
                    InterpolationPoint(
                        x: 2,
                        y: 4
                    )
                ],
                targetX: 1.5
            )

        let result =
            try engine.interpolate(
                method: .lagrange,
                input: input
            )

        #expect(
            abs(
                result.interpolatedY -
                2.25
            ) < tolerance
        )

        #expect(
            result.polynomialDegree == 2
        )

        #expect(
            result.isExtrapolation == false
        )
    }

    @Test("Returns exact known point")
    func returnsExactKnownPoint()
        throws {

        let input =
            NumericalInterpolationInput(
                points: [
                    InterpolationPoint(
                        x: 0,
                        y: 5
                    ),
                    InterpolationPoint(
                        x: 1,
                        y: 10
                    ),
                    InterpolationPoint(
                        x: 2,
                        y: 20
                    )
                ],
                targetX: 1
            )

        let result =
            try engine.interpolate(
                method: .lagrange,
                input: input
            )

        #expect(
            abs(
                result.interpolatedY - 10
            ) < tolerance
        )
    }

    @Test("Sorts unordered data points")
    func sortsUnorderedDataPoints()
        throws {

        let input =
            NumericalInterpolationInput(
                points: [
                    InterpolationPoint(
                        x: 10,
                        y: 20
                    ),
                    InterpolationPoint(
                        x: 0,
                        y: 0
                    )
                ],
                targetX: 5
            )

        let result =
            try engine.interpolate(
                method: .linear,
                input: input
            )

        #expect(
            abs(
                result.interpolatedY - 10
            ) < tolerance
        )

        #expect(result.lowerBound == 0)
        #expect(result.upperBound == 10)
    }

    @Test("Rejects duplicate x values")
    func rejectsDuplicateXValues() {
        let input =
            NumericalInterpolationInput(
                points: [
                    InterpolationPoint(
                        x: 1,
                        y: 5
                    ),
                    InterpolationPoint(
                        x: 1,
                        y: 10
                    )
                ],
                targetX: 1
            )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Each data point must have a unique x value."
                    )
        ) {
            try engine.interpolate(
                method: .linear,
                input: input
            )
        }
    }

    @Test("Rejects insufficient Lagrange points")
    func rejectsInsufficientPoints() {
        let input =
            NumericalInterpolationInput(
                points: [
                    InterpolationPoint(
                        x: 0,
                        y: 1
                    )
                ],
                targetX: 0.5
            )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "At least 2 data points are required for Lagrange Interpolation."
                    )
        ) {
            try engine.interpolate(
                method: .lagrange,
                input: input
            )
        }
    }

    @Test("Rejects extra linear points")
    func rejectsExtraLinearPoints() {
        let input =
            NumericalInterpolationInput(
                points: [
                    InterpolationPoint(
                        x: 0,
                        y: 0
                    ),
                    InterpolationPoint(
                        x: 1,
                        y: 1
                    ),
                    InterpolationPoint(
                        x: 2,
                        y: 4
                    )
                ],
                targetX: 0.5
            )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Linear Interpolation requires exactly 2 data points."
                    )
        ) {
            try engine.interpolate(
                method: .linear,
                input: input
            )
        }
    }
}
