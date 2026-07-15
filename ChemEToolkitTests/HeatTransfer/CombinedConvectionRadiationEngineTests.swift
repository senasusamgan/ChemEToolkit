import Foundation
import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Combined Convection and Radiation Engine")
struct CombinedConvectionRadiationEngineTests {

    private let engine =
        CombinedConvectionRadiationEngine()

    private let tolerance =
        0.000001

    @Test(
        "Combines surface convection and radiation"
    )
    func calculatesCombinedHeatTransfer()
        throws {

        let input =
            CombinedConvectionRadiationInput(
                heatTransferCoefficient: 10,
                emissivity: 0.8,
                area: 2,
                surfaceTemperature: 100,
                fluidTemperature: 20,
                surroundingsTemperature: 20
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.convectionHeatTransferRate
                - 1_600
            ) < tolerance
        )

        #expect(
            abs(
                result.radiationHeatTransferRate
                - 1_088.9731656814415
            ) < tolerance
        )

        #expect(
            abs(
                result.totalHeatTransferRate
                - 2_688.9731656814415
            ) < tolerance
        )

        #expect(
            abs(
                result.totalHeatFlux
                - 1_344.4865828407208
            ) < tolerance
        )

        #expect(
            result.direction
                == .surfaceToEnvironment
        )

        #expect(
            result.dominantMode
                == .convection
        )

        #expect(!result.modesOppose)
    }

    @Test(
        "Handles opposing convection and radiation modes"
    )
    func handlesOpposingModes()
        throws {

        let input =
            CombinedConvectionRadiationInput(
                heatTransferCoefficient: 5,
                emissivity: 1,
                area: 1,
                surfaceTemperature: 50,
                fluidTemperature: 20,
                surroundingsTemperature: 100
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.convectionHeatTransferRate
                - 150
            ) < tolerance
        )

        #expect(
            abs(
                result.radiationHeatTransferRate
                - (-481.03267347365727)
            ) < tolerance
        )

        #expect(
            abs(
                result.totalHeatTransferRate
                - (-331.03267347365727)
            ) < tolerance
        )

        #expect(result.modesOppose)

        #expect(
            result.dominantMode
                == .radiation
        )

        #expect(
            result.direction
                == .environmentToSurface
        )
    }

    @Test(
        "Rejects invalid combined-mode inputs"
    )
    func rejectsInvalidInputs() {

        #expect(
            throws:
                CombinedConvectionRadiationError
                    .nonPositiveHeatTransferCoefficient
        ) {
            try engine.calculate(
                input:
                    CombinedConvectionRadiationInput(
                        heatTransferCoefficient: 0,
                        emissivity: 0.8,
                        area: 1,
                        surfaceTemperature: 100,
                        fluidTemperature: 20,
                        surroundingsTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                CombinedConvectionRadiationError
                    .invalidEmissivity
        ) {
            try engine.calculate(
                input:
                    CombinedConvectionRadiationInput(
                        heatTransferCoefficient: 10,
                        emissivity: -0.1,
                        area: 1,
                        surfaceTemperature: 100,
                        fluidTemperature: 20,
                        surroundingsTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                CombinedConvectionRadiationError
                    .fluidTemperatureBelowAbsoluteZero
        ) {
            try engine.calculate(
                input:
                    CombinedConvectionRadiationInput(
                        heatTransferCoefficient: 10,
                        emissivity: 0.8,
                        area: 1,
                        surfaceTemperature: 100,
                        fluidTemperature: -274,
                        surroundingsTemperature: 20
                    )
            )
        }
    }
}
