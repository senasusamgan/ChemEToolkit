import Testing
@testable import ChemEToolkit

@Suite("Numerical Integration Engine")
struct NumericalIntegrationEngineTests {
    private let engine =
        NumericalIntegrationEngine()

    private let tolerance =
        0.00000001

    @Test("Calculates trapezoidal integral")
    func calculatesTrapezoidalIntegral()
        throws {

        let input = NumericalIntegrationInput(
            points: [
                IntegrationPoint(
                    x: 0,
                    y: 0
                ),
                IntegrationPoint(
                    x: 1,
                    y: 1
                ),
                IntegrationPoint(
                    x: 2,
                    y: 4
                )
            ]
        )

        let result =
            try engine.integrate(
                method: .trapezoidal,
                input: input
            )

        #expect(
            abs(result.value - 3) <
            tolerance
        )

        #expect(result.pointCount == 3)
        #expect(result.intervalCount == 2)
        #expect(result.lowerBound == 0)
        #expect(result.upperBound == 2)
    }

    @Test("Supports unequal spacing with trapezoidal rule")
    func supportsUnequalSpacing()
        throws {

        let input = NumericalIntegrationInput(
            points: [
                IntegrationPoint(
                    x: 0,
                    y: 0
                ),
                IntegrationPoint(
                    x: 1,
                    y: 2
                ),
                IntegrationPoint(
                    x: 3,
                    y: 4
                )
            ]
        )

        let result =
            try engine.integrate(
                method: .trapezoidal,
                input: input
            )

        #expect(
            abs(result.value - 7) <
            tolerance
        )

        #expect(
            result.isEquallySpaced ==
            false
        )

        #expect(result.spacing == nil)
    }

    @Test("Calculates Simpson integral")
    func calculatesSimpsonIntegral()
        throws {

        let input = NumericalIntegrationInput(
            points: [
                IntegrationPoint(
                    x: 0,
                    y: 0
                ),
                IntegrationPoint(
                    x: 0.5,
                    y: 0.25
                ),
                IntegrationPoint(
                    x: 1,
                    y: 1
                )
            ]
        )

        let result =
            try engine.integrate(
                method: .simpsonOneThird,
                input: input
            )

        #expect(
            abs(
                result.value -
                (1.0 / 3.0)
            ) < tolerance
        )

        #expect(result.isEquallySpaced)
        #expect(
            abs(
                (result.spacing ?? 0) -
                0.5
            ) < tolerance
        )
    }

    @Test("Rejects insufficient points")
    func rejectsInsufficientPoints() {
        let input = NumericalIntegrationInput(
            points: [
                IntegrationPoint(
                    x: 0,
                    y: 1
                )
            ]
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "At least 2 data points are required for the Trapezoidal Rule."
                    )
        ) {
            try engine.integrate(
                method: .trapezoidal,
                input: input
            )
        }
    }

    @Test("Rejects non-increasing x values")
    func rejectsNonIncreasingValues() {
        let input = NumericalIntegrationInput(
            points: [
                IntegrationPoint(
                    x: 0,
                    y: 1
                ),
                IntegrationPoint(
                    x: 0,
                    y: 2
                )
            ]
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "x values must be entered in strictly increasing order."
                    )
        ) {
            try engine.integrate(
                method: .trapezoidal,
                input: input
            )
        }
    }

    @Test("Rejects odd Simpson interval count")
    func rejectsOddIntervalCount() {
        let input = NumericalIntegrationInput(
            points: [
                IntegrationPoint(
                    x: 0,
                    y: 0
                ),
                IntegrationPoint(
                    x: 1,
                    y: 1
                ),
                IntegrationPoint(
                    x: 2,
                    y: 4
                ),
                IntegrationPoint(
                    x: 3,
                    y: 9
                )
            ]
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Simpson’s 1/3 Rule requires an even number of subintervals."
                    )
        ) {
            try engine.integrate(
                method: .simpsonOneThird,
                input: input
            )
        }
    }

    @Test("Rejects unequal Simpson spacing")
    func rejectsUnequalSpacing() {
        let input = NumericalIntegrationInput(
            points: [
                IntegrationPoint(
                    x: 0,
                    y: 0
                ),
                IntegrationPoint(
                    x: 1,
                    y: 1
                ),
                IntegrationPoint(
                    x: 3,
                    y: 9
                )
            ]
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Simpson’s 1/3 Rule requires equally spaced x values."
                    )
        ) {
            try engine.integrate(
                method: .simpsonOneThird,
                input: input
            )
        }
    }
}
