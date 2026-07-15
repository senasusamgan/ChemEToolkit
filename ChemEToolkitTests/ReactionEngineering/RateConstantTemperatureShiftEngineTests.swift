import Testing
@testable import ChemEToolkit

@Suite("Rate Constant Temperature Shift Engine")
struct RateConstantTemperatureShiftEngineTests {
    private let engine =
        RateConstantTemperatureShiftEngine()

    @Test("Predicts rate constant at a higher temperature")
    func predictsHigherTemperature() throws {
        let result = try engine.calculate(
            .init(
                referenceRateConstant:
                    0.019696844058205553,
                referenceTemperature: 300,
                targetTemperature: 350,
                activationEnergy: 50_000
            )
        )

        #expect(
            abs(
                result.targetRateConstant
                - 0.3451868704390958
            ) < 1e-12
        )
        #expect(result.rateConstantRatio > 1)
        #expect(
            result.percentRateConstantChange
            > 0
        )
    }

    @Test("Returns unchanged k at equal temperatures")
    func equalTemperatures() throws {
        let result = try engine.calculate(
            .init(
                referenceRateConstant: 2,
                referenceTemperature: 350,
                targetTemperature: 350,
                activationEnergy: 50_000
            )
        )

        #expect(result.targetRateConstant == 2)
        #expect(result.rateConstantRatio == 1)
        #expect(result.percentRateConstantChange == 0)
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(
            throws:
                RateConstantTemperatureShiftError
                    .nonPositiveReferenceRateConstant
        ) {
            try engine.calculate(
                .init(
                    referenceRateConstant: 0,
                    referenceTemperature: 300,
                    targetTemperature: 350,
                    activationEnergy: 50_000
                )
            )
        }

        #expect(
            throws:
                RateConstantTemperatureShiftError
                    .negativeActivationEnergy
        ) {
            try engine.calculate(
                .init(
                    referenceRateConstant: 1,
                    referenceTemperature: 300,
                    targetTemperature: 350,
                    activationEnergy: -1
                )
            )
        }

        #expect(
            throws:
                RateConstantTemperatureShiftError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    referenceRateConstant: .nan,
                    referenceTemperature: 300,
                    targetTemperature: 350,
                    activationEnergy: 50_000
                )
            )
        }
    }
}
