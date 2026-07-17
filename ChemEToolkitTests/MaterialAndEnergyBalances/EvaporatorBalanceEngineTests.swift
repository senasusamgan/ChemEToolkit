import Testing
@testable import ChemEToolkit

@Suite("Evaporator Balance Engine")
struct EvaporatorBalanceEngineTests {
    private let engine =
        EvaporatorBalanceEngine()

    @Test("Calculates concentrated product and vapor")
    func evaporation() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 1000,
                feedSoluteMassFraction: 0.10,
                productSoluteMassFraction: 0.40
            )
        )

        #expect(result.feedSoluteFlow == 100)
        #expect(result.feedSolventFlow == 900)
        #expect(result.concentratedProductFlow == 250)
        #expect(result.productSolventFlow == 150)
        #expect(result.evaporatedSolventFlow == 750)
        #expect(result.concentrationFactor == 4)

        #expect(
            abs(
                result.solventRemovalFraction
                - 5.0 / 6.0
            ) < 1e-12
        )
    }

    @Test("Equal concentration removes no solvent")
    func noEvaporation() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 1000,
                feedSoluteMassFraction: 0.10,
                productSoluteMassFraction: 0.10
            )
        )

        #expect(
            abs(
                result.evaporatedSolventFlow
            ) < 1e-12
        )
    }

    @Test("Rejects diluted product target")
    func validation() {
        #expect(
            throws:
                EvaporatorBalanceError
                    .invalidProductConcentration
        ) {
            try engine.calculate(
                .init(
                    feedMassFlow: 1000,
                    feedSoluteMassFraction: 0.20,
                    productSoluteMassFraction: 0.10
                )
            )
        }
    }
}
