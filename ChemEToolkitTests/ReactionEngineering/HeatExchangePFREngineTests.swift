import Testing
@testable import ChemEToolkit

@Suite("Heat-Exchange PFR Engine")
struct HeatExchangePFREngineTests {
    private let engine = HeatExchangePFREngine()

    @Test("Integrates a cooled PFR")
    func cooledPFR() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 100,
                inletVolumetricFlowRate: 0.01,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                inletTemperature: 350,
                adiabaticTemperatureRise: 100,
                coolantTemperature: 330,
                heatRemovalCoefficient: 0.05,
                targetConversion: 0.8
            )
        )

        #expect(abs(result.requiredSpaceTime - 13.072405489110011) < 1e-8)
        #expect(abs(result.outletTemperature - 401.67304301647329) < 1e-8)
        #expect(abs(result.minimumTemperature - 350) < 1e-8)
        #expect(abs(result.maximumTemperature - 401.67304301647329) < 1e-8)
        #expect(result.heatExchangeToAdiabaticVolumeRatio > 1)
    }

    @Test("Zero heat removal equals the adiabatic PFR")
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
                heatRemovalCoefficient: 0,
                targetConversion: 0.8
            )
        )

        #expect(abs(result.outletTemperature - 430) < 1e-8)
        #expect(abs(result.heatExchangeToAdiabaticVolumeRatio - 1) < 1e-8)
    }

    @Test("Rejects invalid PFR inputs")
    func validation() {
        #expect(throws: HeatExchangePFRError.negativeHeatRemovalCoefficient) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    inletVolumetricFlowRate: 0.01,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    coolantTemperature: 330,
                    heatRemovalCoefficient: -0.05,
                    targetConversion: 0.8
                )
            )
        }

        #expect(throws: HeatExchangePFRError.conversionOutOfRange) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    inletVolumetricFlowRate: 0.01,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    coolantTemperature: 330,
                    heatRemovalCoefficient: 0.05,
                    targetConversion: 1
                )
            )
        }

        #expect(throws: HeatExchangePFRError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    inletConcentrationA: .nan,
                    inletVolumetricFlowRate: 0.01,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    inletTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    coolantTemperature: 330,
                    heatRemovalCoefficient: 0.05,
                    targetConversion: 0.8
                )
            )
        }
    }
}
