import Testing
@testable import ChemEToolkit

@Suite("Pressure-Process Dynamics Engine")
struct PressureProcessDynamicsEngineTests {
    private let engine = PressureProcessDynamicsEngine()

    @Test("Calculates ideal-gas pressure response")
    func response() throws {
        let result = try engine.calculate(
            .init(
                vesselVolume: 1,
                gasTemperature: 300,
                pressureFlowResistance: 50000,
                initialPressure: 100000,
                molarInflowStepChange: 0.5,
                evaluationTime: 10,
                maximumAllowablePressure: 150000
            )
        )

        #expect(abs(result.gasCapacitance - 0.00040090785014242015) < 1e-15)
        #expect(abs(result.processTimeConstant - 20.045392507121008) < 1e-12)
        #expect(abs(result.pressureAtEvaluationTime - 109819.55528306695) < 1e-8)
        #expect(result.finalSteadyPressure == 125000)
        #expect(!result.overpressureRisk)
    }

    @Test("Detects eventual overpressure")
    func overpressure() throws {
        let result = try engine.calculate(
            .init(
                vesselVolume: 1,
                gasTemperature: 300,
                pressureFlowResistance: 50000,
                initialPressure: 100000,
                molarInflowStepChange: 2,
                evaluationTime: 1,
                maximumAllowablePressure: 150000
            )
        )

        #expect(result.finalSteadyPressure == 200000)
        #expect(result.overpressureRisk)
    }

    @Test("Rejects nonphysical steady pressure")
    func validation() {
        #expect(
            throws:
                PressureProcessDynamicsError
                    .nonPhysicalSteadyPressure
        ) {
            try engine.calculate(
                .init(
                    vesselVolume: 1,
                    gasTemperature: 300,
                    pressureFlowResistance: 50000,
                    initialPressure: 100000,
                    molarInflowStepChange: -3,
                    evaluationTime: 1,
                    maximumAllowablePressure: 150000
                )
            )
        }
    }
}
