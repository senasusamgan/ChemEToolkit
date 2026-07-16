import Testing
@testable import ChemEToolkit

@Suite("Cohen-Coon Tuning Engine")
struct CohenCoonTuningEngineTests {
    private let engine =
        CohenCoonTuningEngine()

    @Test("Calculates Cohen-Coon P PI and PID settings")
    func tuning() throws {
        let result = try engine.calculate(
            .init(
                processGain: 2,
                processTimeConstant: 10,
                processDeadTime: 2
            )
        )

        #expect(
            abs(
                result.proportionalGain
                - 2.6666666666666665
            ) < 1e-12
        )

        #expect(
            abs(
                result.piGain
                - 2.291666666666667
            ) < 1e-12
        )

        #expect(
            abs(
                result.piIntegralTime
                - 4.7076923076923078
            ) < 1e-12
        )

        #expect(
            abs(
                result.pidGain
                - 3.458333333333333
            ) < 1e-12
        )

        #expect(
            abs(
                result.pidIntegralTime
                - 4.5479452054794525
            ) < 1e-12
        )

        #expect(
            abs(
                result.pidDerivativeTime
                - 0.70175438596491224
            ) < 1e-12
        )
    }

    @Test("Preserves controller-gain sign")
    func negativeGain() throws {
        let result = try engine.calculate(
            .init(
                processGain: -2,
                processTimeConstant: 10,
                processDeadTime: 2
            )
        )

        #expect(result.proportionalGain < 0)
        #expect(result.piGain < 0)
        #expect(result.pidGain < 0)
    }

    @Test("Rejects excessive dead-time ratio")
    func validation() {
        #expect(
            throws:
                CohenCoonTuningError
                    .deadTimeRatioOutOfRange
        ) {
            try engine.calculate(
                .init(
                    processGain: 2,
                    processTimeConstant: 2,
                    processDeadTime: 3
                )
            )
        }
    }
}
