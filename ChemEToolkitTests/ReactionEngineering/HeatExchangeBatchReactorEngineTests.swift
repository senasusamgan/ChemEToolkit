import Testing
@testable import ChemEToolkit

@Suite("Heat-Exchange Batch Reactor Engine")
struct HeatExchangeBatchReactorEngineTests {
    private let engine = HeatExchangeBatchReactorEngine()

    @Test("Integrates a cooled batch reactor")
    func cooledBatch() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 100,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                initialTemperature: 350,
                adiabaticTemperatureRise: 100,
                coolantTemperature: 330,
                heatRemovalCoefficient: 0.05,
                targetConversion: 0.8,
                maximumIntegrationTime: 200
            )
        )

        #expect(abs(result.timeToTargetConversion - 13.072407442820712) < 1e-8)
        #expect(abs(result.finalTemperature - 401.67303477705156) < 1e-8)
        #expect(abs(result.maximumTemperature - 401.69359463904084) < 1e-8)
        #expect(abs(result.finalConcentrationA - 20) < 1e-12)
        #expect(result.finalTemperature < 430)
    }

    @Test("Zero heat removal recovers the adiabatic boundary")
    func adiabaticBoundary() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 100,
                preExponentialFactor: 1_000_000,
                activationEnergy: 50_000,
                initialTemperature: 350,
                adiabaticTemperatureRise: 100,
                coolantTemperature: 330,
                heatRemovalCoefficient: 0,
                targetConversion: 0.8,
                maximumIntegrationTime: 200
            )
        )

        #expect(abs(result.finalTemperature - 430) < 1e-6)
        #expect(abs(result.heatRemovedTemperatureEquivalent) < 1e-6)
    }

    @Test("Rejects unreachable and invalid cases")
    func validation() {
        #expect(throws: HeatExchangeBatchReactorError.targetNotReached) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 100,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    initialTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    coolantTemperature: 330,
                    heatRemovalCoefficient: 0.05,
                    targetConversion: 0.8,
                    maximumIntegrationTime: 0.01
                )
            )
        }

        #expect(throws: HeatExchangeBatchReactorError.negativeHeatRemovalCoefficient) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 100,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    initialTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    coolantTemperature: 330,
                    heatRemovalCoefficient: -0.05,
                    targetConversion: 0.8,
                    maximumIntegrationTime: 200
                )
            )
        }

        #expect(throws: HeatExchangeBatchReactorError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    initialConcentrationA: .nan,
                    preExponentialFactor: 1_000_000,
                    activationEnergy: 50_000,
                    initialTemperature: 350,
                    adiabaticTemperatureRise: 100,
                    coolantTemperature: 330,
                    heatRemovalCoefficient: 0.05,
                    targetConversion: 0.8,
                    maximumIntegrationTime: 200
                )
            )
        }
    }
}
