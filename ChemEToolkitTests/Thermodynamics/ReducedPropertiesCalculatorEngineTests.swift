import Testing
@testable import ChemEToolkit

@Suite("Reduced Properties Calculator Engine")
struct ReducedPropertiesCalculatorEngineTests {
    private let engine =
        ReducedPropertiesCalculatorEngine()

    @Test("Calculates reduced properties")
    func reducedProperties() throws {
        let result = try engine.calculate(
            .init(
                temperatureKelvin: 350,
                criticalTemperatureKelvin: 300,
                absolutePressure: 5000,
                criticalPressure: 10000
            )
        )

        #expect(
            abs(
                result.reducedTemperature
                - 7.0 / 6.0
            ) < 1e-12
        )

        #expect(result.reducedPressure == 0.5)
    }

    @Test("Critical state gives unit ratios")
    func criticalState() throws {
        let result = try engine.calculate(
            .init(
                temperatureKelvin: 300,
                criticalTemperatureKelvin: 300,
                absolutePressure: 5000,
                criticalPressure: 5000
            )
        )

        #expect(result.reducedTemperature == 1)
        #expect(result.reducedPressure == 1)
    }

    @Test("Rejects zero critical pressure")
    func validation() {
        #expect(
            throws:
                ReducedPropertiesCalculatorError
                    .nonPositivePressure
        ) {
            try engine.calculate(
                .init(
                    temperatureKelvin: 300,
                    criticalTemperatureKelvin: 300,
                    absolutePressure: 5000,
                    criticalPressure: 0
                )
            )
        }
    }
}
