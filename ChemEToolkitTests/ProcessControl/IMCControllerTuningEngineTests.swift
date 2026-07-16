import Testing
@testable import ChemEToolkit

@Suite("IMC Controller Tuning Engine")
struct IMCControllerTuningEngineTests {
    private let engine =
        IMCControllerTuningEngine()

    @Test("Calculates IMC PI and PID settings")
    func tuning() throws {
        let result = try engine.calculate(
            .init(
                processGain: 2,
                processTimeConstant: 10,
                processDeadTime: 2,
                closedLoopTimeConstant: 4
            )
        )

        #expect(
            abs(
                result.piGain
                - 5.0 / 6.0
            ) < 1e-12
        )

        #expect(result.piIntegralTime == 10)
        #expect(result.pidGain == 1.1)
        #expect(result.pidIntegralTime == 11)

        #expect(
            abs(
                result.pidDerivativeTime
                - 10.0 / 11.0
            ) < 1e-12
        )

        #expect(result.lambdaToDeadTimeRatio == 2)
    }

    @Test("Handles a process without dead time")
    func zeroDeadTime() throws {
        let result = try engine.calculate(
            .init(
                processGain: 2,
                processTimeConstant: 10,
                processDeadTime: 0,
                closedLoopTimeConstant: 4
            )
        )

        #expect(result.piGain == 1.25)
        #expect(result.pidGain == 1.25)
        #expect(result.pidDerivativeTime == 0)
        #expect(result.lambdaToDeadTimeRatio.isInfinite)
    }

    @Test("Rejects invalid IMC inputs")
    func validation() {
        #expect(
            throws:
                IMCControllerTuningError
                    .zeroProcessGain
        ) {
            try engine.calculate(
                .init(
                    processGain: 0,
                    processTimeConstant: 10,
                    processDeadTime: 2,
                    closedLoopTimeConstant: 4
                )
            )
        }

        #expect(
            throws:
                IMCControllerTuningError
                    .nonPositiveClosedLoopTimeConstant
        ) {
            try engine.calculate(
                .init(
                    processGain: 2,
                    processTimeConstant: 10,
                    processDeadTime: 2,
                    closedLoopTimeConstant: 0
                )
            )
        }
    }
}
