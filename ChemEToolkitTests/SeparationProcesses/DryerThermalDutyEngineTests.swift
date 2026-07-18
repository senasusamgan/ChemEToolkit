import Testing
@testable import ChemEToolkit

@Suite("Dryer Thermal Duty Engine")
struct DryerThermalDutyEngineTests {
    private let engine =
        DryerThermalDutyEngine()

    @Test("Calculates dryer heat input")
    func duty() throws {
        let result =
            try engine.calculate(
                .init(
                    drySolidMassFlow: 100,
                    inletMoistureDryBasis: 0.40,
                    outletMoistureDryBasis: 0.10,
                    latentHeatOfVaporization: 2300,
                    sensibleHeatDuty: 20000,
                    thermalEfficiency: 0.75
                )
            )

        #expect(
            abs(
                result.evaporatedWaterFlow
                - 30
            ) < 1e-12
        )

        let expectedLatentDuty =
            69_000.0

        let latentDutyTolerance =
            max(
                1e-9,
                abs(expectedLatentDuty)
                    * 1e-12
            )

        #expect(
            abs(
                result.latentHeatDuty
                - expectedLatentDuty
            ) < latentDutyTolerance
        )

        #expect(
            result.requiredHeatInput
            > result.usefulHeatDuty
        )
    }

    @Test("Higher efficiency lowers required heat")
    func efficiencyTrend() throws {
        let low =
            try engine.calculate(
                .init(
                    drySolidMassFlow: 100,
                    inletMoistureDryBasis: 0.40,
                    outletMoistureDryBasis: 0.10,
                    latentHeatOfVaporization: 2300,
                    sensibleHeatDuty: 20000,
                    thermalEfficiency: 0.60
                )
            )

        let high =
            try engine.calculate(
                .init(
                    drySolidMassFlow: 100,
                    inletMoistureDryBasis: 0.40,
                    outletMoistureDryBasis: 0.10,
                    latentHeatOfVaporization: 2300,
                    sensibleHeatDuty: 20000,
                    thermalEfficiency: 0.90
                )
            )

        #expect(
            high.requiredHeatInput
            < low.requiredHeatInput
        )
    }

    @Test("Rejects efficiency above one")
    func validation() {
        #expect(
            throws:
                DryerThermalDutyError
                    .invalidEfficiency
        ) {
            try engine.calculate(
                .init(
                    drySolidMassFlow: 100,
                    inletMoistureDryBasis: 0.40,
                    outletMoistureDryBasis: 0.10,
                    latentHeatOfVaporization: 2300,
                    sensibleHeatDuty: 20000,
                    thermalEfficiency: 1.2
                )
            )
        }
    }
}
