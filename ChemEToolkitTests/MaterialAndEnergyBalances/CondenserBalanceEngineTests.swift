import Testing
@testable import ChemEToolkit

@Suite("Condenser Balance Engine")
struct CondenserBalanceEngineTests {
    private let engine =
        CondenserBalanceEngine()

    @Test("Calculates condensate and vent gas")
    func condensation() throws {
        let result = try engine.calculate(
            .init(
                vaporFeedMassFlow: 1000,
                condensableMassFraction: 0.80,
                condensableCondensationFraction: 0.75
            )
        )

        #expect(result.feedCondensableFlow == 800)
        #expect(result.feedNoncondensableFlow == 200)
        #expect(result.condensateLiquidFlow == 600)
        #expect(result.uncondensedVaporFlow == 200)
        #expect(result.ventGasFlow == 400)
        #expect(result.ventCondensableMassFraction == 0.50)
        #expect(result.overallCondensationFraction == 0.60)
    }

    @Test("Complete condensation leaves only noncondensables")
    func completeCondensation() throws {
        let result = try engine.calculate(
            .init(
                vaporFeedMassFlow: 1000,
                condensableMassFraction: 0.80,
                condensableCondensationFraction: 1
            )
        )

        #expect(result.condensateLiquidFlow == 800)
        #expect(result.ventGasFlow == 200)
        #expect(result.ventCondensableMassFraction == 0)
    }

    @Test("Rejects condensation fraction above one")
    func validation() {
        #expect(
            throws:
                CondenserBalanceError
                    .fractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    vaporFeedMassFlow: 1000,
                    condensableMassFraction: 0.80,
                    condensableCondensationFraction: 1.1
                )
            )
        }
    }
}
