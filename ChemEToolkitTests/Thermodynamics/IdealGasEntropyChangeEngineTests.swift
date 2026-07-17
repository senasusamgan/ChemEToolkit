import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Ideal Gas Entropy Change Engine")
struct IdealGasEntropyChangeEngineTests {
    private let engine =
        IdealGasEntropyChangeEngine()

    @Test("Calculates entropy change")
    func entropyChange() throws {
        let result = try engine.calculate(
            .init(
                mass: 1,
                specificHeatAtConstantPressure: 1.005,
                specificGasConstant: 0.287,
                initialTemperatureKelvin: 300,
                finalTemperatureKelvin: 500,
                initialAbsolutePressure: 100,
                finalAbsolutePressure: 500
            )
        )

        let expected =
            1.005 * log(500.0 / 300.0)
            - 0.287 * log(500.0 / 100.0)

        #expect(
            abs(
                result.specificEntropyChange
                - expected
            ) < 1e-12
        )

        #expect(
            abs(
                result.totalEntropyChange
                - expected
            ) < 1e-12
        )

        #expect(
            abs(
                result.specificHeatAtConstantVolume
                - 0.718
            ) < 1e-12
        )
    }

    @Test("Identical states give zero entropy change")
    func noChange() throws {
        let result = try engine.calculate(
            .init(
                mass: 1,
                specificHeatAtConstantPressure: 1.005,
                specificGasConstant: 0.287,
                initialTemperatureKelvin: 300,
                finalTemperatureKelvin: 300,
                initialAbsolutePressure: 100,
                finalAbsolutePressure: 100
            )
        )

        #expect(
            abs(
                result.totalEntropyChange
            ) < 1e-12
        )
    }

    @Test("Rejects nonpositive pressure")
    func validation() {
        #expect(
            throws:
                IdealGasEntropyChangeError
                    .nonPositivePressure
        ) {
            try engine.calculate(
                .init(
                    mass: 1,
                    specificHeatAtConstantPressure: 1.005,
                    specificGasConstant: 0.287,
                    initialTemperatureKelvin: 300,
                    finalTemperatureKelvin: 500,
                    initialAbsolutePressure: 0,
                    finalAbsolutePressure: 500
                )
            )
        }
    }
}
