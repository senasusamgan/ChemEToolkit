import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Incompressible Entropy Change Engine")
struct IncompressibleEntropyChangeEngineTests {
    private let engine =
        IncompressibleEntropyChangeEngine()

    @Test("Calculates liquid entropy change")
    func entropyChange() throws {
        let result = try engine.calculate(
            .init(
                mass: 10,
                specificHeatCapacity: 4.18,
                initialTemperatureKelvin: 300,
                finalTemperatureKelvin: 350
            )
        )

        let expectedSpecific =
            4.18 * log(350.0 / 300.0)

        #expect(
            abs(
                result.specificEntropyChange
                - expectedSpecific
            ) < 1e-12
        )

        #expect(
            abs(
                result.totalEntropyChange
                - 10 * expectedSpecific
            ) < 1e-12
        )
    }

    @Test("Equal temperatures give zero entropy change")
    func noChange() throws {
        let result = try engine.calculate(
            .init(
                mass: 10,
                specificHeatCapacity: 4.18,
                initialTemperatureKelvin: 300,
                finalTemperatureKelvin: 300
            )
        )

        #expect(
            abs(
                result.totalEntropyChange
            ) < 1e-12
        )
    }

    @Test("Rejects zero kelvin")
    func validation() {
        #expect(
            throws:
                IncompressibleEntropyChangeError
                    .nonPositiveTemperature
        ) {
            try engine.calculate(
                .init(
                    mass: 10,
                    specificHeatCapacity: 4.18,
                    initialTemperatureKelvin: 0,
                    finalTemperatureKelvin: 300
                )
            )
        }
    }
}
