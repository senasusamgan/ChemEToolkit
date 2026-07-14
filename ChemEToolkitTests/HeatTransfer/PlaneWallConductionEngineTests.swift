import Testing
@testable import ChemEToolkit

@Suite("Plane Wall Conduction Engine")
struct PlaneWallConductionEngineTests {

    private let engine =
        PlaneWallConductionEngine()

    private let tolerance =
        0.000001

    @Test("Calculates conduction through a plane wall")
    func calculatesPlaneWallConduction()
        throws {

        let input =
            PlaneWallConductionInput(
                thermalConductivity: 0.8,
                area: 10,
                wallThickness: 0.2,
                hotSideTemperature: 100,
                coldSideTemperature: 20
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(
                result.temperatureDifference
                - 80
            ) < tolerance
        )

        #expect(
            abs(
                result.thermalResistance
                - 0.025
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferRate
                - 3_200
            ) < tolerance
        )

        #expect(
            abs(
                result.heatFlux
                - 320
            ) < tolerance
        )
    }

    @Test("Returns zero heat transfer at equal temperatures")
    func returnsZeroAtEqualTemperatures()
        throws {

        let input =
            PlaneWallConductionInput(
                thermalConductivity: 1.5,
                area: 4,
                wallThickness: 0.1,
                hotSideTemperature: 35,
                coldSideTemperature: 35
            )

        let result =
            try engine.calculate(
                input: input
            )

        #expect(
            abs(result.temperatureDifference)
                < tolerance
        )

        #expect(
            abs(result.heatTransferRate)
                < tolerance
        )

        #expect(
            abs(result.heatFlux)
                < tolerance
        )

        #expect(
            result.thermalResistance > 0
        )
    }

    @Test("Rejects invalid conduction inputs")
    func rejectsInvalidInputs() {

        #expect(
            throws:
                PlaneWallConductionError
                    .nonPositiveThermalConductivity
        ) {
            try engine.calculate(
                input:
                    PlaneWallConductionInput(
                        thermalConductivity: 0,
                        area: 5,
                        wallThickness: 0.2,
                        hotSideTemperature: 80,
                        coldSideTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                PlaneWallConductionError
                    .nonPositiveArea
        ) {
            try engine.calculate(
                input:
                    PlaneWallConductionInput(
                        thermalConductivity: 0.5,
                        area: 0,
                        wallThickness: 0.2,
                        hotSideTemperature: 80,
                        coldSideTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                PlaneWallConductionError
                    .invalidTemperatureOrder
        ) {
            try engine.calculate(
                input:
                    PlaneWallConductionInput(
                        thermalConductivity: 0.5,
                        area: 5,
                        wallThickness: 0.2,
                        hotSideTemperature: 20,
                        coldSideTemperature: 80
                    )
            )
        }
    }
}
