import Testing
@testable import ChemEToolkit

@Suite("Space Time Space Velocity Engine")
struct SpaceTimeSpaceVelocityEngineTests {
    private let engine =
        SpaceTimeSpaceVelocityEngine()

    @Test("Calculates space time, LHSV and holdup time")
    func calculatesMetrics() throws {
        let result = try engine.calculate(
            .init(
                reactorVolume: 5,
                inletVolumetricFlowRate: 0.002,
                fluidHoldupFraction: 0.4
            )
        )

        #expect(
            result.spaceTimeSeconds
            == 2500
        )
        #expect(
            abs(
                result.spaceTimeHours
                - 0.6944444444444444
            ) < 1e-12
        )
        #expect(
            abs(
                result.spaceVelocityPerHour
                - 1.44
            ) < 1e-12
        )
        #expect(
            result.fluidHoldupVolume
            == 2
        )
        #expect(
            result
                .fluidHoldupResidenceTimeSeconds
            == 1000
        )
        #expect(
            abs(
                result.interstitialSpaceVelocityPerHour
                - 3.6
            ) < 1e-12
        )
        #expect(
            abs(
                result.dailyVolumetricThroughput
                - 172.8
            ) < 1e-12
        )
    }

    @Test("Full holdup equals nominal space time")
    func fullHoldupBoundary() throws {
        let result = try engine.calculate(
            .init(
                reactorVolume: 5,
                inletVolumetricFlowRate: 0.002,
                fluidHoldupFraction: 1
            )
        )

        #expect(
            result
                .fluidHoldupResidenceTimeSeconds
            == result.spaceTimeSeconds
        )
        #expect(
            result
                .interstitialSpaceVelocityPerHour
            == result.spaceVelocityPerHour
        )
    }

    @Test("Rejects invalid volume, flow and holdup")
    func validation() {
        #expect(
            throws:
                SpaceTimeSpaceVelocityError
                    .nonPositiveVolumeOrFlow
        ) {
            try engine.calculate(
                .init(
                    reactorVolume: 0,
                    inletVolumetricFlowRate: 0.002,
                    fluidHoldupFraction: 0.4
                )
            )
        }

        #expect(
            throws:
                SpaceTimeSpaceVelocityError
                    .holdupFractionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    reactorVolume: 5,
                    inletVolumetricFlowRate: 0.002,
                    fluidHoldupFraction: 1.1
                )
            )
        }

        #expect(
            throws:
                SpaceTimeSpaceVelocityError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    reactorVolume: .nan,
                    inletVolumetricFlowRate: 0.002,
                    fluidHoldupFraction: 0.4
                )
            )
        }
    }
}
