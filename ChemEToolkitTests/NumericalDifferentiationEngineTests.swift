import Testing
@testable import ChemEToolkit

@Suite("Numerical Differentiation Engine")
struct NumericalDifferentiationEngineTests {
    private let engine =
        NumericalDifferentiationEngine()

    private let tolerance =
        0.00000001

    @Test("Calculates forward difference")
    func calculatesForwardDifference()
        throws {

        let input =
            NumericalDifferentiationInput(
                points: [
                    DifferentiationPoint(
                        x: 0,
                        y: 0
                    ),
                    DifferentiationPoint(
                        x: 1,
                        y: 1
                    ),
                    DifferentiationPoint(
                        x: 2,
                        y: 4
                    )
                ],
                targetX: 1
            )

        let result =
            try engine.differentiate(
                method: .forward,
                input: input
            )

        #expect(
            abs(
                result.derivative - 3
            ) < tolerance
        )

        #expect(
            result.usedPoints.count == 2
        )
    }

    @Test("Calculates backward difference")
    func calculatesBackwardDifference()
        throws {

        let input =
            NumericalDifferentiationInput(
                points: [
                    DifferentiationPoint(
                        x: 0,
                        y: 0
                    ),
                    DifferentiationPoint(
                        x: 1,
                        y: 1
                    ),
                    DifferentiationPoint(
                        x: 2,
                        y: 4
                    )
                ],
                targetX: 1
            )

        let result =
            try engine.differentiate(
                method: .backward,
                input: input
            )

        #expect(
            abs(
                result.derivative - 1
            ) < tolerance
        )
    }

    @Test("Calculates central difference")
    func calculatesCentralDifference()
        throws {

        let input =
            NumericalDifferentiationInput(
                points: [
                    DifferentiationPoint(
                        x: 0,
                        y: 0
                    ),
                    DifferentiationPoint(
                        x: 1,
                        y: 1
                    ),
                    DifferentiationPoint(
                        x: 2,
                        y: 4
                    )
                ],
                targetX: 1
            )

        let result =
            try engine.differentiate(
                method: .central,
                input: input
            )

        #expect(
            abs(
                result.derivative - 2
            ) < tolerance
        )

        #expect(
            result.isEquallySpaced
        )

        #expect(
            abs(
                (result.spacing ?? 0) - 1
            ) < tolerance
        )
    }

    @Test("Supports unequal central spacing")
    func supportsUnequalCentralSpacing()
        throws {

        let input =
            NumericalDifferentiationInput(
                points: [
                    DifferentiationPoint(
                        x: 0,
                        y: 0
                    ),
                    DifferentiationPoint(
                        x: 1,
                        y: 1
                    ),
                    DifferentiationPoint(
                        x: 3,
                        y: 9
                    )
                ],
                targetX: 1
            )

        let result =
            try engine.differentiate(
                method: .central,
                input: input
            )

        #expect(
            abs(
                result.derivative - 2
            ) < tolerance
        )

        #expect(
            result.isEquallySpaced ==
            false
        )

        #expect(result.spacing == nil)
    }

    @Test("Sorts unordered points")
    func sortsUnorderedPoints()
        throws {

        let input =
            NumericalDifferentiationInput(
                points: [
                    DifferentiationPoint(
                        x: 2,
                        y: 4
                    ),
                    DifferentiationPoint(
                        x: 0,
                        y: 0
                    ),
                    DifferentiationPoint(
                        x: 1,
                        y: 1
                    )
                ],
                targetX: 1
            )

        let result =
            try engine.differentiate(
                method: .central,
                input: input
            )

        #expect(
            abs(
                result.derivative - 2
            ) < tolerance
        )

        #expect(result.lowerBound == 0)
        #expect(result.upperBound == 2)
    }

    @Test("Rejects unknown target x")
    func rejectsUnknownTargetX() {
        let input =
            NumericalDifferentiationInput(
                points: [
                    DifferentiationPoint(
                        x: 0,
                        y: 0
                    ),
                    DifferentiationPoint(
                        x: 1,
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
                            "Target x must match one of the entered data points."
                    )
        ) {
            try engine.differentiate(
                method: .forward,
                input: input
            )
        }
    }

    @Test("Rejects forward difference at final point")
    func rejectsForwardAtFinalPoint() {
        let input =
            NumericalDifferentiationInput(
                points: [
                    DifferentiationPoint(
                        x: 0,
                        y: 0
                    ),
                    DifferentiationPoint(
                        x: 1,
                        y: 1
                    )
                ],
                targetX: 1
            )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Forward Difference requires a data point after the target x value."
                    )
        ) {
            try engine.differentiate(
                method: .forward,
                input: input
            )
        }
    }

    @Test("Rejects backward difference at first point")
    func rejectsBackwardAtFirstPoint() {
        let input =
            NumericalDifferentiationInput(
                points: [
                    DifferentiationPoint(
                        x: 0,
                        y: 0
                    ),
                    DifferentiationPoint(
                        x: 1,
                        y: 1
                    )
                ],
                targetX: 0
            )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Backward Difference requires a data point before the target x value."
                    )
        ) {
            try engine.differentiate(
                method: .backward,
                input: input
            )
        }
    }

    @Test("Rejects central difference at endpoint")
    func rejectsCentralAtEndpoint() {
        let input =
            NumericalDifferentiationInput(
                points: [
                    DifferentiationPoint(
                        x: 0,
                        y: 0
                    ),
                    DifferentiationPoint(
                        x: 1,
                        y: 1
                    ),
                    DifferentiationPoint(
                        x: 2,
                        y: 4
                    )
                ],
                targetX: 0
            )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Central Difference requires data points on both sides of the target x value."
                    )
        ) {
            try engine.differentiate(
                method: .central,
                input: input
            )
        }
    }

    @Test("Rejects duplicate x values")
    func rejectsDuplicateXValues() {
        let input =
            NumericalDifferentiationInput(
                points: [
                    DifferentiationPoint(
                        x: 1,
                        y: 2
                    ),
                    DifferentiationPoint(
                        x: 1,
                        y: 3
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
            try engine.differentiate(
                method: .forward,
                input: input
            )
        }
    }
}
