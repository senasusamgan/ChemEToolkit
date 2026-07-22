import Testing
@testable import ChemEToolkit

@Suite("Adaptive Control Engine")
struct AdaptiveControlEngineTests {
    private let engine =
        AdaptiveControlEngine()

    @Test("Updates gain in tracking-improvement direction")
    func adaptiveUpdate() throws {
        let result = try engine.calculate(
            .init(
                currentControllerGain: 2,
                referenceOutput: 10,
                measuredOutput: 8,
                modelOutputSensitivity: 0.5,
                adaptationRate: 0.2,
                sampleTime: 1,
                minimumControllerGain: 0,
                maximumControllerGain: 5
            )
        )

        #expect(result.trackingError == 2)
        #expect(result.adaptationSignal == 1)
        #expect(result.requestedGainUpdate == 0.2)
        #expect(
            abs(
                result.appliedGainUpdate
                - 0.2
            ) < 1e-12
        )

        #expect(result.updatedControllerGain == 2.2)

        #expect(
            abs(
                result.predictedTrackingError
                - 1.9
            ) < 1e-12
        )

        #expect(
            result.predictedTrackingCost
            < result.currentTrackingCost
        )
    }

    @Test("Projects adaptive gain onto limits")
    func projection() throws {
        let result = try engine.calculate(
            .init(
                currentControllerGain: 4.9,
                referenceOutput: 10,
                measuredOutput: 0,
                modelOutputSensitivity: 1,
                adaptationRate: 1,
                sampleTime: 1,
                minimumControllerGain: 0,
                maximumControllerGain: 5
            )
        )

        #expect(result.updatedControllerGain == 5)

        #expect(
            abs(
                result.appliedGainUpdate
                - 0.1
            ) < 1e-12
        )

        #expect(result.gainLimitIsActive)
    }

    @Test("Rejects invalid adaptation settings")
    func validation() {
        #expect(
            throws:
                AdaptiveControlError
                    .negativeAdaptationRate
        ) {
            try engine.calculate(
                .init(
                    currentControllerGain: 2,
                    referenceOutput: 10,
                    measuredOutput: 8,
                    modelOutputSensitivity: 0.5,
                    adaptationRate: -0.2,
                    sampleTime: 1,
                    minimumControllerGain: 0,
                    maximumControllerGain: 5
                )
            )
        }
    }
}
