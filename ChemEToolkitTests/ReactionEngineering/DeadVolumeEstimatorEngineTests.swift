import Testing
@testable import ChemEToolkit

@Suite("Dead Volume Estimator Engine")
struct DeadVolumeEstimatorEngineTests {
    private let engine =
        DeadVolumeEstimatorEngine()

    @Test("Estimates active and dead volume")
    func estimatesVolume() throws {
        let result = try engine.calculate(
            .init(
                nominalReactorVolume: 10,
                volumetricFlowRate: 1,
                measuredMeanResidenceTime: 8
            )
        )

        #expect(result.nominalSpaceTime == 10)
        #expect(result.activeVolume == 8)
        #expect(result.deadVolume == 2)
        #expect(
            abs(
                result.deadVolumeFraction
                - 0.2
            ) < 1e-12
        )
    }

    @Test("No dead volume at nominal space time")
    func noDeadVolume() throws {
        let result = try engine.calculate(
            .init(
                nominalReactorVolume: 10,
                volumetricFlowRate: 1,
                measuredMeanResidenceTime: 10
            )
        )

        #expect(
            abs(result.deadVolume)
            < 1e-12
        )
        #expect(
            abs(
                result.activeVolumeFraction
                - 1
            ) < 1e-12
        )
    }

    @Test("Rejects invalid dead-volume interpretation")
    func validation() {
        #expect(
            throws:
                DeadVolumeEstimatorError
                    .measuredResidenceTimeExceedsNominal
        ) {
            try engine.calculate(
                .init(
                    nominalReactorVolume: 10,
                    volumetricFlowRate: 1,
                    measuredMeanResidenceTime: 11
                )
            )
        }

        #expect(
            throws:
                DeadVolumeEstimatorError
                    .nonPositiveVolumeOrFlow
        ) {
            try engine.calculate(
                .init(
                    nominalReactorVolume: 10,
                    volumetricFlowRate: 0,
                    measuredMeanResidenceTime: 8
                )
            )
        }
    }
}
