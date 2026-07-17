import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Polytropic Ideal-Gas Process Engine")
struct PolytropicIdealGasProcessEngineTests {
    private let engine =
        PolytropicIdealGasProcessEngine()

    @Test("Calculates expansion state and work")
    func expansion() throws {
        let result = try engine.calculate(
            .init(
                initialAbsolutePressure: 1000,
                initialVolume: 1,
                finalAbsolutePressure: 200,
                polytropicExponent: 1.3
            )
        )

        let expectedVolume =
            pow(
                1000.0 / 200.0,
                1.0 / 1.3
            )

        let expectedWork =
            (
                200 * expectedVolume
                - 1000
            )
            / (
                1 - 1.3
            )

        #expect(
            abs(
                result.finalVolume
                - expectedVolume
            ) < 1e-12
        )

        #expect(
            abs(
                result.workBySystem
                - expectedWork
            ) < 1e-9
        )
    }

    @Test("Equal pressures preserve volume")
    func noChange() throws {
        let result = try engine.calculate(
            .init(
                initialAbsolutePressure: 100,
                initialVolume: 1,
                finalAbsolutePressure: 100,
                polytropicExponent: 1.3
            )
        )

        #expect(result.finalVolume == 1)
        #expect(result.workBySystem == 0)
    }

    @Test("Rejects exponent of one")
    func validation() {
        #expect(
            throws:
                PolytropicIdealGasProcessError
                    .isothermalExponentUnsupported
        ) {
            try engine.calculate(
                .init(
                    initialAbsolutePressure: 1000,
                    initialVolume: 1,
                    finalAbsolutePressure: 200,
                    polytropicExponent: 1
                )
            )
        }
    }
}
