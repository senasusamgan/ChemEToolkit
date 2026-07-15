import Foundation
import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Thermal Radiation Engine")
struct ThermalRadiationEngineTests {

    private let engine =
        ThermalRadiationEngine()

    private let tolerance =
        0.000001

    @Test(
        "Calculates radiation from a hot surface"
    )
    func calculatesSurfaceToSurroundingsRadiation()
        throws {

        let input =
            ThermalRadiationInput(
                emissivity: 1,
                area: 1,
                surfaceTemperature: 100,
                surroundingsTemperature: 0
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.heatTransferRate
                - 783.7163262575966
            ) < tolerance
        )

        #expect(
            abs(
                result.heatFlux
                - 783.7163262575966
            ) < tolerance
        )

        #expect(
            abs(
                result.effectiveRadiationCoefficient
                - 7.837163262575967
            ) < tolerance
        )

        #expect(
            result.direction
                == .surfaceToSurroundings
        )
    }

    @Test(
        "Preserves reverse radiation direction"
    )
    func calculatesSurroundingsToSurfaceRadiation()
        throws {

        let input =
            ThermalRadiationInput(
                emissivity: 0.5,
                area: 2,
                surfaceTemperature: 20,
                surroundingsTemperature: 80
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.heatTransferRate
                - (-463.19345081951855)
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferRateMagnitude
                - 463.19345081951855
            ) < tolerance
        )

        #expect(
            abs(
                result.heatFlux
                - (-231.59672540975927)
            ) < tolerance
        )

        #expect(
            result.direction
                == .surroundingsToSurface
        )
    }

    @Test(
        "Rejects invalid radiation inputs"
    )
    func rejectsInvalidInputs() {

        #expect(
            throws:
                ThermalRadiationError
                    .invalidEmissivity
        ) {
            try engine.calculate(
                input:
                    ThermalRadiationInput(
                        emissivity: 1.2,
                        area: 1,
                        surfaceTemperature: 100,
                        surroundingsTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                ThermalRadiationError
                    .nonPositiveArea
        ) {
            try engine.calculate(
                input:
                    ThermalRadiationInput(
                        emissivity: 0.8,
                        area: 0,
                        surfaceTemperature: 100,
                        surroundingsTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                ThermalRadiationError
                    .surfaceTemperatureBelowAbsoluteZero
        ) {
            try engine.calculate(
                input:
                    ThermalRadiationInput(
                        emissivity: 0.8,
                        area: 1,
                        surfaceTemperature: -274,
                        surroundingsTemperature: 20
                    )
            )
        }
    }
}
