import Testing
@testable import ChemEToolkit

@Suite(
    "Crosscurrent Liquid–Liquid Extraction Engine"
)
struct CrosscurrentLiquidLiquidExtractionEngineTests {
    private let engine =
        CrosscurrentLiquidLiquidExtractionEngine()

    @Test(
        "Calculates repeated extraction with equal solvent portions"
    )
    func calculatesCrosscurrentExtraction()
        throws {

        let result = try engine.calculate(
            .init(
                raffinateCarrierFlowRate: 100,
                totalFreshSolventFlowRate:
                    100,
                feedSoluteRatio: 0.2,
                freshSolventSoluteRatio: 0,
                distributionCoefficient: 2,
                numberOfStages: 3
            )
        )

        #expect(
            result.numberOfStages == 3
        )
        #expect(
            abs(
                result.solventFlowPerStage
                - 33.333333333333336
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalRaffinateSoluteRatio
                - 0.0432
            ) < 1e-12
        )
        #expect(
            abs(
                result.overallRemovalFraction
                - 0.784
            ) < 1e-12
        )
        #expect(
            abs(
                result.totalTransferRate
                - 15.68
            ) < 1e-12
        )
    }

    @Test(
        "Reduces to the single-stage result for one stage"
    )
    func oneStageBoundary() throws {
        let result = try engine.calculate(
            .init(
                raffinateCarrierFlowRate: 100,
                totalFreshSolventFlowRate:
                    50,
                feedSoluteRatio: 0.2,
                freshSolventSoluteRatio: 0,
                distributionCoefficient: 3,
                numberOfStages: 1
            )
        )

        #expect(
            abs(
                result.finalRaffinateSoluteRatio
                - 0.08
            ) < 1e-12
        )
        #expect(
            abs(
                result.overallRemovalFraction
                - 0.6
            ) < 1e-12
        )
    }

    @Test(
        "Rejects fractional stages, reverse transfer and nonfinite values"
    )
    func validation() {
        #expect(
            throws:
                CrosscurrentLiquidLiquidExtractionError
                    .invalidStageCount
        ) {
            try engine.calculate(
                .init(
                    raffinateCarrierFlowRate:
                        100,
                    totalFreshSolventFlowRate:
                        100,
                    feedSoluteRatio: 0.2,
                    freshSolventSoluteRatio:
                        0,
                    distributionCoefficient:
                        2,
                    numberOfStages: 2.5
                )
            )
        }

        #expect(
            throws:
                CrosscurrentLiquidLiquidExtractionError
                    .reverseTransferAtFeed
        ) {
            try engine.calculate(
                .init(
                    raffinateCarrierFlowRate:
                        100,
                    totalFreshSolventFlowRate:
                        100,
                    feedSoluteRatio: 0.1,
                    freshSolventSoluteRatio:
                        0.3,
                    distributionCoefficient:
                        2,
                    numberOfStages: 2
                )
            )
        }

        #expect(
            throws:
                CrosscurrentLiquidLiquidExtractionError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    raffinateCarrierFlowRate:
                        .nan,
                    totalFreshSolventFlowRate:
                        100,
                    feedSoluteRatio: 0.2,
                    freshSolventSoluteRatio:
                        0,
                    distributionCoefficient:
                        2,
                    numberOfStages: 3
                )
            )
        }
    }
}
