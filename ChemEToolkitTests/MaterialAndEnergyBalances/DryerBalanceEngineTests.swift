import Testing
@testable import ChemEToolkit

@Suite("Dryer Balance Engine")
struct DryerBalanceEngineTests {
    private let engine =
        DryerBalanceEngine()

    @Test("Calculates dried-product and water removal")
    func drying() throws {
        let result = try engine.calculate(
            .init(
                wetFeedMassFlow: 1000,
                initialMoistureWetBasis: 0.40,
                targetMoistureWetBasis: 0.10
            )
        )

        #expect(result.drySolidFlow == 600)
        #expect(result.initialWaterFlow == 400)

        #expect(
            abs(
                result.driedProductFlow
                - 666.6666666666666
            ) < 1e-10
        )

        #expect(
            abs(
                result.finalWaterFlow
                - 66.66666666666663
            ) < 1e-10
        )

        #expect(
            abs(
                result.waterRemovedFlow
                - 333.33333333333337
            ) < 1e-10
        )

        #expect(
            abs(
                result.finalMoistureDryBasis
                - 1.0 / 9.0
            ) < 1e-12
        )
    }

    @Test("Equal moisture target removes no water")
    func noDrying() throws {
        let result = try engine.calculate(
            .init(
                wetFeedMassFlow: 1000,
                initialMoistureWetBasis: 0.40,
                targetMoistureWetBasis: 0.40
            )
        )

        #expect(
            abs(
                result.waterRemovedFlow
            ) < 1e-12
        )
    }

    @Test("Rejects target above initial moisture")
    func validation() {
        #expect(
            throws:
                DryerBalanceError
                    .invalidDryingTarget
        ) {
            try engine.calculate(
                .init(
                    wetFeedMassFlow: 1000,
                    initialMoistureWetBasis: 0.40,
                    targetMoistureWetBasis: 0.50
                )
            )
        }
    }
}
