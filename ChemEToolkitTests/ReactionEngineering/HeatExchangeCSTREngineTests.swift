import Testing
@testable import ChemEToolkit

@Suite("Heat-Exchange CSTR Engine")
struct HeatExchangeCSTREngineTests {
    private let engine = HeatExchangeCSTREngine()

    @Test("Sizes a cooled CSTR")
    func cooledCSTR() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 100,
                inletVolumetricFlowRate: 0.01,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                inletTemperature: 350,
                adiabaticTemperatureRise: 100,
                coolantTemperature: 330,
                heatRemovalNumber: 1.5,
                targetConversion: 0.8
            )
        )

        #expect(abs(result.outletTemperature - 370) < 1e-12)
        #expect(abs(result.adiabaticOutletTemperature - 430) < 1e-12)
        #expect(abs(result.outletRateConstant - 0.087378118003909294) < 1e-12)
        #expect(abs(result.requiredReactorVolume - 0.45778051660726332) < 1e-12)
        #expect(abs(result.adiabaticReactorVolume - 0.047395460745733593) < 1e-12)
        #expect(result.requiredReactorVolume > result.adiabaticReactorVolume)
    }

    @Test("Zero heat removal equals adiabatic sizing")
    func adiabaticBoundary() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 100,
                inletVolumetricFlowRate: 0.01,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                inletTemperature: 350,
                adiabaticTemperatureRise: 100,
                coolantTemperature: 330,
                heatRemovalNumber: 0,
                targetConversion: 0.8
            )
        )

        #expect(result.outletTemperature == result.adiabaticOutletTemperature)
        #expect(abs(result.heatExchangeToAdiabaticVolumeRatio - 1) < 1e-12)
    }

    @Test("Rejects invalid CSTR inputs")
    func validation() {
        #expect(throws: HeatExchangeCSTRError.negativeHeatRemovalNumber) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    inletVolumetricFlowRate: 0.01,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    coolantTemperature: 330,
                    heatRemovalNumber: -1,
                    targetConversion: 0.8
                )
            )
        }

        #expect(throws: HeatExchangeCSTRError.conversionOutOfRange) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    inletVolumetricFlowRate: 0.01,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    coolantTemperature: 330,
                    heatRemovalNumber: 1.5,
                    targetConversion: 1
                )
            )
        }

        #expect(throws: HeatExchangeCSTRError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    inletConcentrationA: .nan,
                    inletVolumetricFlowRate: 0.01,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    coolantTemperature: 330,
                    heatRemovalNumber: 1.5,
                    targetConversion: 0.8
                )
            )
        }
    }
}
