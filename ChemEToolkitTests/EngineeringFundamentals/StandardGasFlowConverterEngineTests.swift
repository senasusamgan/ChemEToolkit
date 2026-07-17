import Testing
@testable import ChemEToolkit

@Suite("Standard Gas Flow Converter Engine")
struct StandardGasFlowConverterEngineTests {
    private let engine =
        StandardGasFlowConverterEngine()

    @Test("Converts actual flow to standard conditions")
    func standardFlow() throws {
        let result = try engine.calculate(
            .init(
                actualVolumetricFlowRate: 100,
                actualAbsolutePressure: 200_000,
                actualTemperatureKelvin: 320,
                standardAbsolutePressure: 100_000,
                standardTemperatureKelvin: 288
            )
        )

        #expect(result.pressureCorrectionFactor == 2)
        #expect(result.temperatureCorrectionFactor == 0.9)

        #expect(
            abs(
                result.standardVolumetricFlowRate
                - 180
            ) < 1e-12
        )
    }

    @Test("Identical conditions preserve flow")
    func identicalConditions() throws {
        let result = try engine.calculate(
            .init(
                actualVolumetricFlowRate: 50,
                actualAbsolutePressure: 101_325,
                actualTemperatureKelvin: 273.15,
                standardAbsolutePressure: 101_325,
                standardTemperatureKelvin: 273.15
            )
        )

        #expect(result.standardVolumetricFlowRate == 50)
        #expect(result.standardToActualFlowRatio == 1)
    }

    @Test("Rejects zero absolute pressure")
    func validation() {
        #expect(
            throws:
                StandardGasFlowConverterError
                    .nonPositivePressure
        ) {
            try engine.calculate(
                .init(
                    actualVolumetricFlowRate: 100,
                    actualAbsolutePressure: 0,
                    actualTemperatureKelvin: 320,
                    standardAbsolutePressure: 101_325,
                    standardTemperatureKelvin: 273.15
                )
            )
        }
    }
}
