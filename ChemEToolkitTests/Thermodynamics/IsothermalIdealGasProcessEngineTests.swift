import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Isothermal Ideal-Gas Process Engine")
struct IsothermalIdealGasProcessEngineTests {
    private let engine =
        IsothermalIdealGasProcessEngine()

    @Test("Calculates reversible expansion work")
    func expansion() throws {
        let result = try engine.calculate(
            .init(
                amountKilomoles: 1,
                temperatureKelvin: 300,
                initialAbsolutePressure: 500,
                finalAbsolutePressure: 100
            )
        )

        let expected =
            8.31446261815324
            * 300
            * log(5.0)

        #expect(
            abs(
                result.workBySystem
                - expected
            ) < 1e-9
        )

        #expect(result.volumeRatio == 5)
        #expect(result.heatToSystem == result.workBySystem)
        #expect(result.internalEnergyChange == 0)
    }

    @Test("Equal pressures give zero work")
    func noChange() throws {
        let result = try engine.calculate(
            .init(
                amountKilomoles: 1,
                temperatureKelvin: 300,
                initialAbsolutePressure: 100,
                finalAbsolutePressure: 100
            )
        )

        #expect(result.workBySystem == 0)
        #expect(result.volumeRatio == 1)
    }

    @Test("Rejects zero final pressure")
    func validation() {
        #expect(
            throws:
                IsothermalIdealGasProcessError
                    .nonPositivePressure
        ) {
            try engine.calculate(
                .init(
                    amountKilomoles: 1,
                    temperatureKelvin: 300,
                    initialAbsolutePressure: 100,
                    finalAbsolutePressure: 0
                )
            )
        }
    }
}
