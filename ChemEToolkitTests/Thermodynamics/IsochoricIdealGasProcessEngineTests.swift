import Testing
@testable import ChemEToolkit

@Suite("Isochoric Ideal-Gas Process Engine")
struct IsochoricIdealGasProcessEngineTests {
    private let engine =
        IsochoricIdealGasProcessEngine()

    @Test("Calculates rigid-vessel heating")
    func heating() throws {
        let result = try engine.calculate(
            .init(
                mass: 1,
                specificHeatAtConstantVolume: 0.718,
                initialTemperatureKelvin: 300,
                finalTemperatureKelvin: 500
            )
        )

        #expect(
            abs(
                result.internalEnergyChange
                - 143.6
            ) < 1e-12
        )

        #expect(result.heatToSystem == result.internalEnergyChange)
        #expect(result.workBySystem == 0)

        #expect(
            abs(
                result.pressureRatio
                - 5.0 / 3.0
            ) < 1e-12
        )
    }

    @Test("Equal temperatures preserve pressure")
    func noChange() throws {
        let result = try engine.calculate(
            .init(
                mass: 1,
                specificHeatAtConstantVolume: 0.718,
                initialTemperatureKelvin: 300,
                finalTemperatureKelvin: 300
            )
        )

        #expect(result.internalEnergyChange == 0)
        #expect(result.pressureRatio == 1)
    }

    @Test("Rejects zero initial temperature")
    func validation() {
        #expect(
            throws:
                IsochoricIdealGasProcessError
                    .nonPositiveTemperature
        ) {
            try engine.calculate(
                .init(
                    mass: 1,
                    specificHeatAtConstantVolume: 0.718,
                    initialTemperatureKelvin: 0,
                    finalTemperatureKelvin: 300
                )
            )
        }
    }
}
