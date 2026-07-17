import Testing
@testable import ChemEToolkit

@Suite("Enthalpy Change Calculator Engine")
struct EnthalpyChangeCalculatorEngineTests {
    private let engine =
        EnthalpyChangeCalculatorEngine()

    @Test("Calculates positive enthalpy change")
    func heating() throws {
        let result = try engine.calculate(
            .init(
                mass: 2,
                specificHeatAtConstantPressure: 4.18,
                initialTemperature: 20,
                finalTemperature: 80
            )
        )

        #expect(result.temperatureChange == 60)

        #expect(
            abs(
                result.specificEnthalpyChange
                - 250.8
            ) < 1e-12
        )

        #expect(
            abs(
                result.totalEnthalpyChange
                - 501.6
            ) < 1e-12
        )
    }

    @Test("Cooling gives negative enthalpy change")
    func cooling() throws {
        let result = try engine.calculate(
            .init(
                mass: 1,
                specificHeatAtConstantPressure: 2,
                initialTemperature: 100,
                finalTemperature: 40
            )
        )

        #expect(result.totalEnthalpyChange == -120)
    }

    @Test("Rejects zero heat capacity")
    func validation() {
        #expect(
            throws:
                EnthalpyChangeCalculatorError
                    .nonPositiveHeatCapacity
        ) {
            try engine.calculate(
                .init(
                    mass: 1,
                    specificHeatAtConstantPressure: 0,
                    initialTemperature: 20,
                    finalTemperature: 80
                )
            )
        }
    }
}
