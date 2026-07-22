import Testing
@testable import ChemEToolkit

@Suite("Sensible Heat Balance Engine")
struct SensibleHeatBalanceEngineTests {
    private let engine =
        SensibleHeatBalanceEngine()

    @Test("Calculates heating duty")
    func heating() throws {
        let result = try engine.calculate(
            .init(
                massFlowRate: 2,
                specificHeatCapacity: 4.18,
                inletTemperature: 20,
                outletTemperature: 80
            )
        )

        #expect(result.temperatureChange == 60)

        #expect(
            abs(
                result.signedHeatDuty
                - 501.6
            ) < 1e-12
        )

        #expect(result.processDirection == "Heating")
    }

    @Test("Cooling produces negative signed duty")
    func cooling() throws {
        let result = try engine.calculate(
            .init(
                massFlowRate: 1,
                specificHeatCapacity: 2,
                inletTemperature: 100,
                outletTemperature: 40
            )
        )

        #expect(result.signedHeatDuty == -120)
        #expect(result.absoluteHeatDuty == 120)
        #expect(result.processDirection == "Cooling")
    }

    @Test("Rejects zero heat capacity")
    func validation() {
        #expect(
            throws:
                SensibleHeatBalanceError
                    .nonPositiveHeatCapacity
        ) {
            try engine.calculate(
                .init(
                    massFlowRate: 1,
                    specificHeatCapacity: 0,
                    inletTemperature: 20,
                    outletTemperature: 80
                )
            )
        }
    }
}
