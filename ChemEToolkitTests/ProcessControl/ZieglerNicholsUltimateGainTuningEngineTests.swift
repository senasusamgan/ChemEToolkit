import Testing
@testable import ChemEToolkit

@Suite("Ziegler-Nichols Ultimate-Gain Tuning Engine")
struct ZieglerNicholsUltimateGainTuningEngineTests {
    private let engine =
        ZieglerNicholsUltimateGainTuningEngine()

    @Test("Calculates classic P PI and PID settings")
    func tuning() throws {
        let result = try engine.calculate(
            .init(
                ultimateGain: 8,
                ultimatePeriod: 6
            )
        )

        #expect(result.proportionalGain == 4)
        #expect(result.piGain == 3.6)
        #expect(result.piIntegralTime == 5)
        #expect(result.pidGain == 4.8)
        #expect(result.pidIntegralTime == 3)
        #expect(result.pidDerivativeTime == 0.75)

        #expect(
            abs(
                result.ultimateFrequency
                - 2
                * Double.pi
                / 6
            ) < 1e-12
        )
    }

    @Test("Tuning scales with ultimate gain and period")
    func scaling() throws {
        let result = try engine.calculate(
            .init(
                ultimateGain: 10,
                ultimatePeriod: 8
            )
        )

        #expect(result.proportionalGain == 5)
        #expect(result.piIntegralTime == 8 / 1.2)
        #expect(result.pidDerivativeTime == 1)
    }

    @Test("Rejects invalid ultimate conditions")
    func validation() {
        #expect(
            throws:
                ZieglerNicholsUltimateGainTuningError
                    .nonPositiveUltimateGain
        ) {
            try engine.calculate(
                .init(
                    ultimateGain: 0,
                    ultimatePeriod: 6
                )
            )
        }

        #expect(
            throws:
                ZieglerNicholsUltimateGainTuningError
                    .nonPositiveUltimatePeriod
        ) {
            try engine.calculate(
                .init(
                    ultimateGain: 8,
                    ultimatePeriod: 0
                )
            )
        }
    }
}
