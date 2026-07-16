import Testing
@testable import ChemEToolkit

@Suite("Ziegler-Nichols Reaction-Curve Tuning Engine")
struct ZieglerNicholsReactionCurveTuningEngineTests {
    private let engine =
        ZieglerNicholsReactionCurveTuningEngine()

    @Test("Calculates FOPDT reaction-curve settings")
    func tuning() throws {
        let result = try engine.calculate(
            .init(
                processGain: 2,
                processTimeConstant: 10,
                processDeadTime: 2
            )
        )

        #expect(result.proportionalGain == 2.5)
        #expect(result.piGain == 2.25)
        #expect(result.piIntegralTime == 6.66)
        #expect(result.pidGain == 3)
        #expect(result.pidIntegralTime == 4)
        #expect(result.pidDerivativeTime == 1)
        #expect(result.deadTimeRatio == 0.2)
    }

    @Test("Preserves a negative process-gain sign")
    func negativeGain() throws {
        let result = try engine.calculate(
            .init(
                processGain: -2,
                processTimeConstant: 10,
                processDeadTime: 2
            )
        )

        #expect(result.proportionalGain == -2.5)
        #expect(result.piGain == -2.25)
        #expect(result.pidGain == -3)
    }

    @Test("Rejects zero gain and dead time")
    func validation() {
        #expect(
            throws:
                ZieglerNicholsReactionCurveTuningError
                    .zeroProcessGain
        ) {
            try engine.calculate(
                .init(
                    processGain: 0,
                    processTimeConstant: 10,
                    processDeadTime: 2
                )
            )
        }

        #expect(
            throws:
                ZieglerNicholsReactionCurveTuningError
                    .nonPositiveDeadTime
        ) {
            try engine.calculate(
                .init(
                    processGain: 2,
                    processTimeConstant: 10,
                    processDeadTime: 0
                )
            )
        }
    }
}
