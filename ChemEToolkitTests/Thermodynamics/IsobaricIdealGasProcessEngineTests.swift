import Testing
@testable import ChemEToolkit

@Suite("Isobaric Ideal-Gas Process Engine")
struct IsobaricIdealGasProcessEngineTests {
    private let engine =
        IsobaricIdealGasProcessEngine()

    @Test("Calculates constant-pressure heating")
    func heating() throws {
        let result = try engine.calculate(
            .init(
                mass: 1,
                specificHeatAtConstantPressure: 1.005,
                specificGasConstant: 0.287,
                initialTemperatureKelvin: 300,
                finalTemperatureKelvin: 500
            )
        )

        #expect(
            abs(
                result.heatToSystem - 201
            ) < 1e-12
        )

        #expect(
            abs(
                result.workBySystem - 57.4
            ) < 1e-12
        )

        #expect(
            abs(
                result.internalEnergyChange
                - 143.6
            ) < 1e-12
        )
    }

    @Test("Equal temperatures give zero energy changes")
    func noChange() throws {
        let result = try engine.calculate(
            .init(
                mass: 1,
                specificHeatAtConstantPressure: 1.005,
                specificGasConstant: 0.287,
                initialTemperatureKelvin: 300,
                finalTemperatureKelvin: 300
            )
        )

        #expect(result.heatToSystem == 0)
        #expect(result.workBySystem == 0)
        #expect(result.volumeRatio == 1)
    }

    @Test("Rejects Cp not exceeding R")
    func validation() {
        #expect(
            throws:
                IsobaricIdealGasProcessError
                    .invalidHeatCapacityRelation
        ) {
            try engine.calculate(
                .init(
                    mass: 1,
                    specificHeatAtConstantPressure: 0.2,
                    specificGasConstant: 0.287,
                    initialTemperatureKelvin: 300,
                    finalTemperatureKelvin: 500
                )
            )
        }
    }
}
