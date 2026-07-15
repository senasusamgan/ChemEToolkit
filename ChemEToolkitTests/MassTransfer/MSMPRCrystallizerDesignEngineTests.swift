import Testing
@testable import ChemEToolkit

@Suite("MSMPR Crystallizer Design Engine")
struct MSMPRCrystallizerDesignEngineTests {
    private let engine =
        MSMPRCrystallizerDesignEngine()

    @Test(
        "Calculates ideal MSMPR moments, loading and production"
    )
    func calculatesDistribution() throws {
        let result = try engine.calculate(
            .init(
                residenceTime: 2,
                linearCrystalGrowthRate:
                    0.0005,
                nucleiPopulationDensity:
                    100_000_000,
                crystalDensity: 2500,
                crystalVolumeShapeFactor:
                    0.5,
                slurryVolumetricFlowRate:
                    0.1,
                evaluationCrystalSize:
                    0.002
            )
        )

        #expect(
            abs(
                result.characteristicCrystalSize
                - 0.001
            ) < 1e-15
        )
        #expect(
            abs(
                result.totalCrystalNumberConcentration
                - 100_000
            ) < 1e-9
        )
        #expect(
            abs(
                result.solidsVolumeFraction
                - 0.0003
            ) < 1e-15
        )
        #expect(
            abs(
                result.crystalMassConcentration
                - 0.75
            ) < 1e-12
        )
        #expect(
            abs(
                result.crystalProductionRate
                - 0.075
            ) < 1e-12
        )
        #expect(
            abs(
                result.populationDensityAtEvaluationSize
                - 13_533_528.323661271
            ) < 1e-6
        )
        #expect(
            abs(
                result.fractionByNumberAboveEvaluationSize
                - 0.1353352832366127
            ) < 1e-15
        )
    }

    @Test(
        "Uses the nuclei density at zero evaluation size"
    )
    func zeroSizeBoundary() throws {
        let result = try engine.calculate(
            .init(
                residenceTime: 2,
                linearCrystalGrowthRate:
                    0.0005,
                nucleiPopulationDensity:
                    100_000_000,
                crystalDensity: 2500,
                crystalVolumeShapeFactor:
                    0.5,
                slurryVolumetricFlowRate:
                    0.1,
                evaluationCrystalSize:
                    0
            )
        )

        #expect(
            result.populationDensityAtEvaluationSize
            == 100_000_000
        )
        #expect(
            result.fractionByNumberAboveEvaluationSize
            == 1
        )
        #expect(
            abs(
                result.volumeWeightedMeanSize
                - 0.004
            ) < 1e-15
        )
    }

    @Test(
        "Rejects invalid properties, negative size and concentrated slurry"
    )
    func validation() {
        #expect(
            throws:
                MSMPRCrystallizerDesignError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    residenceTime: 0,
                    linearCrystalGrowthRate:
                        0.0005,
                    nucleiPopulationDensity:
                        100_000_000,
                    crystalDensity: 2500,
                    crystalVolumeShapeFactor:
                        0.5,
                    slurryVolumetricFlowRate:
                        0.1,
                    evaluationCrystalSize:
                        0.002
                )
            )
        }

        #expect(
            throws:
                MSMPRCrystallizerDesignError
                    .negativeEvaluationSize
        ) {
            try engine.calculate(
                .init(
                    residenceTime: 2,
                    linearCrystalGrowthRate:
                        0.0005,
                    nucleiPopulationDensity:
                        100_000_000,
                    crystalDensity: 2500,
                    crystalVolumeShapeFactor:
                        0.5,
                    slurryVolumetricFlowRate:
                        0.1,
                    evaluationCrystalSize:
                        -0.001
                )
            )
        }

        #expect(
            throws:
                MSMPRCrystallizerDesignError
                    .solidsFractionOutsideDiluteModel
        ) {
            try engine.calculate(
                .init(
                    residenceTime: 2,
                    linearCrystalGrowthRate:
                        0.0005,
                    nucleiPopulationDensity:
                        100_000_000_000,
                    crystalDensity: 2500,
                    crystalVolumeShapeFactor:
                        0.5,
                    slurryVolumetricFlowRate:
                        0.1,
                    evaluationCrystalSize:
                        0.002
                )
            )
        }

        #expect(
            throws:
                MSMPRCrystallizerDesignError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    residenceTime: .nan,
                    linearCrystalGrowthRate:
                        0.0005,
                    nucleiPopulationDensity:
                        100_000_000,
                    crystalDensity: 2500,
                    crystalVolumeShapeFactor:
                        0.5,
                    slurryVolumetricFlowRate:
                        0.1,
                    evaluationCrystalSize:
                        0.002
                )
            )
        }
    }
}
