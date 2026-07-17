import Testing
@testable import ChemEToolkit

@Suite("Internal Energy Change Calculator Engine")
struct InternalEnergyChangeCalculatorEngineTests {
    private let engine =
        InternalEnergyChangeCalculatorEngine()

    @Test("Calculates internal-energy change")
    func heating() throws {
        let result = try engine.calculate(
            .init(
                mass: 2,
                specificHeatAtConstantVolume: 0.718,
                initialTemperature: 300,
                finalTemperature: 500
            )
        )

        #expect(result.temperatureChange == 200)

        #expect(
            abs(
                result.specificInternalEnergyChange
                - 143.6
            ) < 1e-12
        )

        #expect(
            abs(
                result.totalInternalEnergyChange
                - 287.2
            ) < 1e-12
        )
    }

    @Test("No temperature change gives zero delta U")
    func noChange() throws {
        let result = try engine.calculate(
            .init(
                mass: 2,
                specificHeatAtConstantVolume: 0.718,
                initialTemperature: 300,
                finalTemperature: 300
            )
        )

        #expect(result.totalInternalEnergyChange == 0)
    }

    @Test("Rejects negative mass")
    func validation() {
        #expect(
            throws:
                InternalEnergyChangeCalculatorError
                    .negativeMass
        ) {
            try engine.calculate(
                .init(
                    mass: -1,
                    specificHeatAtConstantVolume: 0.718,
                    initialTemperature: 300,
                    finalTemperature: 500
                )
            )
        }
    }
}
