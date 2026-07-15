import Testing
@testable import ChemEToolkit

@Suite(
    "Countercurrent Liquid–Liquid Extraction Engine"
)
struct CountercurrentLiquidLiquidExtractionEngineTests {
    private let engine =
        CountercurrentLiquidLiquidExtractionEngine()

    @Test(
        "Calculates ideal stages and achieved outlet"
    )
    func calculatesCountercurrentStages()
        throws {

        let result = try engine.calculate(
            .init(
                raffinateCarrierFlowRate: 100,
                solventCarrierFlowRate: 50,
                distributionCoefficient: 3,
                feedSoluteRatio: 0.2,
                targetRaffinateSoluteRatio:
                    0.02,
                enteringSolventSoluteRatio:
                    0
            )
        )

        #expect(
            abs(
                result.extractionFactor
                - 1.5
            ) < 1e-12
        )
        #expect(
            abs(
                result.continuousIdealStageCount
                - 3.419022582702909
            ) < 1e-12
        )
        #expect(
            result.requiredWholeStageCount
            == 4
        )
        #expect(
            abs(
                result.achievedRaffinateSoluteRatio
                - 0.015165876777251187
            ) < 1e-14
        )
        #expect(
            abs(
                result.solventOutletSoluteRatio
                - 0.36966824644549766
            ) < 1e-12
        )
    }

    @Test(
        "Uses the unity extraction-factor limit"
    )
    func unityFactor() throws {
        let result = try engine.calculate(
            .init(
                raffinateCarrierFlowRate: 100,
                solventCarrierFlowRate: 50,
                distributionCoefficient: 2,
                feedSoluteRatio: 0.2,
                targetRaffinateSoluteRatio:
                    0.05,
                enteringSolventSoluteRatio:
                    0
            )
        )

        #expect(
            abs(
                result.continuousIdealStageCount
                - 3
            ) < 1e-12
        )
        #expect(
            result.requiredWholeStageCount
            == 3
        )
        #expect(
            abs(
                result.achievedRaffinateSoluteRatio
                - 0.05
            ) < 1e-12
        )
    }

    @Test(
        "Rejects unreachable targets, invalid ratios and nonfinite values"
    )
    func validation() {
        #expect(
            throws:
                CountercurrentLiquidLiquidExtractionError
                    .infeasibleTargetForExtractionFactor
        ) {
            try engine.calculate(
                .init(
                    raffinateCarrierFlowRate:
                        100,
                    solventCarrierFlowRate:
                        40,
                    distributionCoefficient:
                        2,
                    feedSoluteRatio: 0.2,
                    targetRaffinateSoluteRatio:
                        0.02,
                    enteringSolventSoluteRatio:
                        0
                )
            )
        }

        #expect(
            throws:
                CountercurrentLiquidLiquidExtractionError
                    .invalidTargetRatio
        ) {
            try engine.calculate(
                .init(
                    raffinateCarrierFlowRate:
                        100,
                    solventCarrierFlowRate:
                        50,
                    distributionCoefficient:
                        3,
                    feedSoluteRatio: 0.2,
                    targetRaffinateSoluteRatio:
                        0.2,
                    enteringSolventSoluteRatio:
                        0
                )
            )
        }

        #expect(
            throws:
                CountercurrentLiquidLiquidExtractionError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    raffinateCarrierFlowRate:
                        .nan,
                    solventCarrierFlowRate:
                        50,
                    distributionCoefficient:
                        3,
                    feedSoluteRatio: 0.2,
                    targetRaffinateSoluteRatio:
                        0.02,
                    enteringSolventSoluteRatio:
                        0
                )
            )
        }
    }
}
