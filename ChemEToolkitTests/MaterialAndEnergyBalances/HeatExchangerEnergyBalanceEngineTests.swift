import Testing
@testable import ChemEToolkit

@Suite("Heat Exchanger Energy Balance Engine")
struct HeatExchangerEnergyBalanceEngineTests {
    private let engine =
        HeatExchangerEnergyBalanceEngine()

    @Test("Solves cold outlet temperature")
    func energyBalance() throws {
        let result = try engine.calculate(
            .init(
                hotMassFlow: 2,
                hotHeatCapacity: 4,
                hotInletTemperature: 150,
                hotOutletTemperature: 90,
                coldMassFlow: 3,
                coldHeatCapacity: 4,
                coldInletTemperature: 20
            )
        )

        #expect(result.heatDuty == 480)
        #expect(result.hotCapacityRate == 8)
        #expect(result.coldCapacityRate == 12)
        #expect(result.coldTemperatureRise == 40)
        #expect(result.coldOutletTemperature == 60)

        #expect(
            abs(
                result.effectiveness
                - 480.0 / 1040.0
            ) < 1e-12
        )
    }

    @Test("No hot-side cooling gives zero duty")
    func zeroDuty() throws {
        let result = try engine.calculate(
            .init(
                hotMassFlow: 2,
                hotHeatCapacity: 4,
                hotInletTemperature: 150,
                hotOutletTemperature: 150,
                coldMassFlow: 3,
                coldHeatCapacity: 4,
                coldInletTemperature: 20
            )
        )

        #expect(result.heatDuty == 0)
        #expect(result.coldOutletTemperature == 20)
    }

    @Test("Rejects impossible duty")
    func validation() {
        #expect(
            throws:
                HeatExchangerEnergyBalanceError
                    .dutyExceedsThermodynamicMaximum
        ) {
            try engine.calculate(
                .init(
                    hotMassFlow: 10,
                    hotHeatCapacity: 4,
                    hotInletTemperature: 100,
                    hotOutletTemperature: 0,
                    coldMassFlow: 1,
                    coldHeatCapacity: 4,
                    coldInletTemperature: 20
                )
            )
        }
    }
}
