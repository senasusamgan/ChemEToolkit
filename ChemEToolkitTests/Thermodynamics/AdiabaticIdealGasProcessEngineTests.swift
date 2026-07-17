import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Adiabatic Ideal-Gas Process Engine")
struct AdiabaticIdealGasProcessEngineTests {
    private let engine =
        AdiabaticIdealGasProcessEngine()

    @Test("Calculates adiabatic expansion")
    func expansion() throws {
        let result = try engine.calculate(
            .init(
                initialTemperatureKelvin: 500,
                initialAbsolutePressure: 1000,
                finalAbsolutePressure: 100,
                heatCapacityRatio: 1.4,
                specificGasConstant: 0.287
            )
        )

        let expectedTemperature =
            500.0
            * pow(
                0.1,
                (1.4 - 1) / 1.4
            )

        #expect(
            abs(
                result.finalTemperatureKelvin
                - expectedTemperature
            ) < 1e-12
        )

        #expect(result.specificWorkBySystem > 0)
        #expect(result.specificInternalEnergyChange < 0)
    }

    @Test("Equal pressures preserve temperature")
    func noChange() throws {
        let result = try engine.calculate(
            .init(
                initialTemperatureKelvin: 500,
                initialAbsolutePressure: 100,
                finalAbsolutePressure: 100,
                heatCapacityRatio: 1.4,
                specificGasConstant: 0.287
            )
        )

        #expect(result.finalTemperatureKelvin == 500)
        #expect(result.volumeRatio == 1)
        #expect(result.specificWorkBySystem == 0)
    }

    @Test("Rejects gamma of one")
    func validation() {
        #expect(
            throws:
                AdiabaticIdealGasProcessError
                    .invalidHeatCapacityRatio
        ) {
            try engine.calculate(
                .init(
                    initialTemperatureKelvin: 500,
                    initialAbsolutePressure: 1000,
                    finalAbsolutePressure: 100,
                    heatCapacityRatio: 1,
                    specificGasConstant: 0.287
                )
            )
        }
    }
}
