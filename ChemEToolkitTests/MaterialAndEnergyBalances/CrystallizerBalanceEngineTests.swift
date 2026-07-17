import Testing
@testable import ChemEToolkit

@Suite("Crystallizer Balance Engine")
struct CrystallizerBalanceEngineTests {
    private let engine =
        CrystallizerBalanceEngine()

    @Test("Calculates crystals and mother liquor")
    func crystallization() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 1000,
                feedSoluteMassFraction: 0.40,
                motherLiquorSoluteMassFraction: 0.20,
                crystalSoluteMassFraction: 0.95
            )
        )

        let expectedCrystal =
            1000.0 * (0.40 - 0.20)
            / (0.95 - 0.20)

        #expect(
            abs(
                result.crystalMassFlow
                - expectedCrystal
            ) < 1e-10
        )

        #expect(
            abs(
                result.crystalMassFlow
                + result.motherLiquorMassFlow
                - 1000
            ) < 1e-10
        )

        #expect(
            abs(
                result.crystalSoluteFlow
                + result.motherLiquorSoluteFlow
                - 400
            ) < 1e-10
        )
    }

    @Test("Feed at mother-liquor composition gives no crystals")
    func noCrystals() throws {
        let result = try engine.calculate(
            .init(
                feedMassFlow: 1000,
                feedSoluteMassFraction: 0.20,
                motherLiquorSoluteMassFraction: 0.20,
                crystalSoluteMassFraction: 0.95
            )
        )

        #expect(result.crystalMassFlow == 0)
        #expect(result.motherLiquorMassFlow == 1000)
    }

    @Test("Rejects feed outside phase-composition range")
    func validation() {
        #expect(
            throws:
                CrystallizerBalanceError
                    .infeasibleFeedComposition
        ) {
            try engine.calculate(
                .init(
                    feedMassFlow: 1000,
                    feedSoluteMassFraction: 0.10,
                    motherLiquorSoluteMassFraction: 0.20,
                    crystalSoluteMassFraction: 0.95
                )
            )
        }
    }
}
