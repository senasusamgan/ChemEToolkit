import Testing
@testable import ChemEToolkit

@Suite(
    "Single-Stage Liquid–Liquid Extraction Engine"
)
struct SingleStageLiquidLiquidExtractionEngineTests {
    private let engine =
        SingleStageLiquidLiquidExtractionEngine()

    @Test(
        "Solves one equilibrium extraction stage"
    )
    func solvesExtraction() throws {
        let result = try engine.calculate(
            .init(
                raffinateCarrierFlowRate: 100,
                solventCarrierFlowRate: 50,
                feedSoluteRatio: 0.2,
                enteringSolventSoluteRatio:
                    0,
                distributionCoefficient: 3
            )
        )

        #expect(
            abs(
                result.raffinateOutletSoluteRatio
                - 0.08
            ) < 1e-12
        )
        #expect(
            abs(
                result.extractOutletSoluteRatio
                - 0.24
            ) < 1e-12
        )
        #expect(
            abs(
                result.transferRateMagnitude
                - 12
            ) < 1e-12
        )
        #expect(
            abs(
                result.raffinateRemovalFraction
                - 0.6
            ) < 1e-12
        )
    }

    @Test(
        "Returns zero transfer when entering phases are at equilibrium"
    )
    func equilibriumBoundary() throws {
        let result = try engine.calculate(
            .init(
                raffinateCarrierFlowRate: 100,
                solventCarrierFlowRate: 50,
                feedSoluteRatio: 0.2,
                enteringSolventSoluteRatio:
                    0.6,
                distributionCoefficient: 3
            )
        )

        #expect(
            abs(
                result.signedTransferRateToExtract
            ) < 1e-12
        )
        #expect(
            abs(
                result.raffinateOutletSoluteRatio
                - 0.2
            ) < 1e-12
        )
    }

    @Test(
        "Rejects invalid flows, ratios and nonfinite values"
    )
    func validation() {
        #expect(
            throws:
                SingleStageLiquidLiquidExtractionError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    raffinateCarrierFlowRate: 0,
                    solventCarrierFlowRate: 50,
                    feedSoluteRatio: 0.2,
                    enteringSolventSoluteRatio:
                        0,
                    distributionCoefficient: 3
                )
            )
        }

        #expect(
            throws:
                SingleStageLiquidLiquidExtractionError
                    .negativeSoluteRatio
        ) {
            try engine.calculate(
                .init(
                    raffinateCarrierFlowRate: 100,
                    solventCarrierFlowRate: 50,
                    feedSoluteRatio: -0.2,
                    enteringSolventSoluteRatio:
                        0,
                    distributionCoefficient: 3
                )
            )
        }

        #expect(
            throws:
                SingleStageLiquidLiquidExtractionError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    raffinateCarrierFlowRate: 100,
                    solventCarrierFlowRate: 50,
                    feedSoluteRatio: .nan,
                    enteringSolventSoluteRatio:
                        0,
                    distributionCoefficient: 3
                )
            )
        }
    }
}
