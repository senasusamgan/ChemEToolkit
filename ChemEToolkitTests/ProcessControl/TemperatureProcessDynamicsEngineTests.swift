import Testing
@testable import ChemEToolkit

@Suite("Temperature-Process Dynamics Engine")
struct TemperatureProcessDynamicsEngineTests {
    private let engine =
        TemperatureProcessDynamicsEngine()

    @Test("Calculates mixed thermal-process response")
    func thermalResponse() throws {
        let result = try engine.calculate(
            .init(
                liquidVolume: 2,
                liquidDensity: 1000,
                specificHeatCapacity: 4180,
                volumetricFlowRate: 0.01,
                overallHeatTransferConductance: 200,
                inletTemperature: 350,
                environmentTemperature: 300,
                initialTemperature: 310,
                evaluationTime: 100
            )
        )

        #expect(result.thermalCapacitance == 8360000)
        #expect(result.flowHeatCapacityRate == 41800)

        #expect(
            abs(
                result.processTimeConstant
                - 199.04761904761904
            ) < 1e-12
        )

        #expect(
            abs(
                result.finalSteadyTemperature
                - 349.76190476190476
            ) < 1e-12
        )

        #expect(
            abs(
                result.temperatureAtEvaluationTime
                - 325.70271720426342
            ) < 1e-12
        )
    }

    @Test("No heat exchange approaches inlet temperature")
    func adiabaticFlowTank() throws {
        let result = try engine.calculate(
            .init(
                liquidVolume: 2,
                liquidDensity: 1000,
                specificHeatCapacity: 4180,
                volumetricFlowRate: 0.01,
                overallHeatTransferConductance: 0,
                inletTemperature: 350,
                environmentTemperature: 300,
                initialTemperature: 310,
                evaluationTime: 100
            )
        )

        #expect(result.finalSteadyTemperature == 350)
        #expect(result.processTimeConstant == 200)
        #expect(result.environmentHeatRateAtEvaluation == 0)
    }

    @Test("Rejects a process without thermal transport")
    func validation() {
        #expect(
            throws:
                TemperatureProcessDynamicsError
                    .invalidTransportParameter
        ) {
            try engine.calculate(
                .init(
                    liquidVolume: 2,
                    liquidDensity: 1000,
                    specificHeatCapacity: 4180,
                    volumetricFlowRate: 0,
                    overallHeatTransferConductance: 0,
                    inletTemperature: 350,
                    environmentTemperature: 300,
                    initialTemperature: 310,
                    evaluationTime: 100
                )
            )
        }
    }
}
