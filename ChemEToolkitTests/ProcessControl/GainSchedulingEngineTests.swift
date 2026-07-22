import Testing
@testable import ChemEToolkit

@Suite("Gain Scheduling Engine")
struct GainSchedulingEngineTests {
    private let engine =
        GainSchedulingEngine()

    @Test("Interpolates controller parameters")
    func interpolation() throws {
        let result = try engine.calculate(
            .init(
                operatingPoint: 60,
                lowerOperatingPoint: 20,
                upperOperatingPoint: 100,
                lowerControllerGain: 1,
                upperControllerGain: 3,
                lowerIntegralTime: 10,
                upperIntegralTime: 4,
                lowerDerivativeTime: 0,
                upperDerivativeTime: 2
            )
        )

        #expect(result.interpolationFraction == 0.5)
        #expect(result.scheduledControllerGain == 2)
        #expect(result.scheduledIntegralTime == 7)
        #expect(result.scheduledDerivativeTime == 1)
        #expect(result.controllerGainSlope == 0.025)
    }

    @Test("Schedule endpoints reproduce endpoint tuning")
    func endpoints() throws {
        let lower = try engine.calculate(
            .init(
                operatingPoint: 20,
                lowerOperatingPoint: 20,
                upperOperatingPoint: 100,
                lowerControllerGain: 1,
                upperControllerGain: 3,
                lowerIntegralTime: 10,
                upperIntegralTime: 4,
                lowerDerivativeTime: 0,
                upperDerivativeTime: 2
            )
        )

        #expect(lower.scheduledControllerGain == 1)
        #expect(lower.scheduledIntegralTime == 10)
        #expect(lower.scheduledDerivativeTime == 0)

        let upper = try engine.calculate(
            .init(
                operatingPoint: 100,
                lowerOperatingPoint: 20,
                upperOperatingPoint: 100,
                lowerControllerGain: 1,
                upperControllerGain: 3,
                lowerIntegralTime: 10,
                upperIntegralTime: 4,
                lowerDerivativeTime: 0,
                upperDerivativeTime: 2
            )
        )

        #expect(upper.scheduledControllerGain == 3)
        #expect(upper.scheduledIntegralTime == 4)
        #expect(upper.scheduledDerivativeTime == 2)
    }

    @Test("Rejects an operating point outside schedule")
    func validation() {
        #expect(
            throws:
                GainSchedulingError
                    .operatingPointOutsideSchedule
        ) {
            try engine.calculate(
                .init(
                    operatingPoint: 120,
                    lowerOperatingPoint: 20,
                    upperOperatingPoint: 100,
                    lowerControllerGain: 1,
                    upperControllerGain: 3,
                    lowerIntegralTime: 10,
                    upperIntegralTime: 4,
                    lowerDerivativeTime: 0,
                    upperDerivativeTime: 2
                )
            )
        }
    }
}
