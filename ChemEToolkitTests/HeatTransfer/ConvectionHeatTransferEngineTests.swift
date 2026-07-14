import Testing
@testable import ChemEToolkit

@Suite("Convection Heat Transfer Engine")
struct ConvectionHeatTransferEngineTests {

    private let engine =
        ConvectionHeatTransferEngine()

    private let tolerance =
        0.000001

    @Test("Calculates heat transfer from surface to fluid")
    func calculatesSurfaceToFluidHeatTransfer()
        throws {

        let input =
            ConvectionHeatTransferInput(
                heatTransferCoefficient: 25,
                area: 4,
                surfaceTemperature: 80,
                fluidTemperature: 20
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(
                result.temperatureDifference
                - 60
            ) < tolerance
        )

        #expect(
            abs(
                result.thermalResistance
                - 0.01
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferRate
                - 6_000
            ) < tolerance
        )

        #expect(
            abs(
                result.heatFlux
                - 1_500
            ) < tolerance
        )

        #expect(
            result.direction
                == .surfaceToFluid
        )
    }

    @Test("Preserves reverse heat-flow direction")
    func calculatesFluidToSurfaceHeatTransfer()
        throws {

        let input =
            ConvectionHeatTransferInput(
                heatTransferCoefficient: 10,
                area: 2,
                surfaceTemperature: 20,
                fluidTemperature: 50
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(
                result.heatTransferRate
                - (-600)
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferRateMagnitude
                - 600
            ) < tolerance
        )

        #expect(
            abs(
                result.heatFlux
                - (-300)
            ) < tolerance
        )

        #expect(
            result.direction
                == .fluidToSurface
        )
    }

    @Test("Rejects invalid convection inputs")
    func rejectsInvalidInputs() {

        #expect(
            throws:
                ConvectionHeatTransferError
                    .nonPositiveHeatTransferCoefficient
        ) {
            try engine.calculate(
                input:
                    ConvectionHeatTransferInput(
                        heatTransferCoefficient: 0,
                        area: 2,
                        surfaceTemperature: 80,
                        fluidTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                ConvectionHeatTransferError
                    .nonPositiveArea
        ) {
            try engine.calculate(
                input:
                    ConvectionHeatTransferInput(
                        heatTransferCoefficient: 15,
                        area: -1,
                        surfaceTemperature: 80,
                        fluidTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                ConvectionHeatTransferError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                input:
                    ConvectionHeatTransferInput(
                        heatTransferCoefficient:
                            .infinity,
                        area: 2,
                        surfaceTemperature: 80,
                        fluidTemperature: 20
                    )
            )
        }
    }
}
