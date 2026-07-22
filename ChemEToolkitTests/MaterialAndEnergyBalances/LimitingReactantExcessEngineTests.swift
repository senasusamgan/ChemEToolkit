import Testing
@testable import ChemEToolkit

@Suite("Limiting Reactant and Excess Engine")
struct LimitingReactantExcessEngineTests {
    private let engine =
        LimitingReactantExcessEngine()

    @Test("Identifies reactant A as limiting")
    func limitingA() throws {
        let result = try engine.calculate(
            .init(
                amountA: 10,
                stoichiometricCoefficientA: 2,
                amountB: 8,
                stoichiometricCoefficientB: 1
            )
        )

        #expect(result.limitingReactant == "Reactant A")
        #expect(result.maximumReactionExtent == 5)
        #expect(result.amountAConsumed == 10)
        #expect(result.amountBConsumed == 5)
        #expect(result.amountARemaining == 0)
        #expect(result.amountBRemaining == 3)
        #expect(result.excessReactant == "Reactant B")
        #expect(result.percentExcess == 60)
    }

    @Test("Detects stoichiometric feed")
    func stoichiometricFeed() throws {
        let result = try engine.calculate(
            .init(
                amountA: 10,
                stoichiometricCoefficientA: 2,
                amountB: 5,
                stoichiometricCoefficientB: 1
            )
        )

        #expect(
            result.limitingReactant
            == "Stoichiometric feed"
        )

        #expect(result.percentExcess == 0)
    }

    @Test("Rejects zero stoichiometric coefficient")
    func validation() {
        #expect(
            throws:
                LimitingReactantExcessError
                    .nonPositiveStoichiometricCoefficient
        ) {
            try engine.calculate(
                .init(
                    amountA: 10,
                    stoichiometricCoefficientA: 0,
                    amountB: 5,
                    stoichiometricCoefficientB: 1
                )
            )
        }
    }
}
