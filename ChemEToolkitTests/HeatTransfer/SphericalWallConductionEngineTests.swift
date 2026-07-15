import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Spherical Wall Conduction Engine")
struct SphericalWallConductionEngineTests {

    private let engine =
        SphericalWallConductionEngine()

    private let tolerance = 0.000001

    @Test("Calculates spherical-shell conduction")
    func calculatesSphericalConduction()
        throws {

        let result = try engine.calculate(
            input:
                SphericalWallConductionInput(
                    thermalConductivity: 1,
                    innerRadius: 1,
                    outerRadius: 2,
                    innerSurfaceTemperature: 1,
                    outerSurfaceTemperature: 0
                )
        )

        #expect(
            abs(
                result.thermalResistance
                - 1 / (8 * Double.pi)
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferRate
                - 8 * Double.pi
            ) < tolerance
        )

        #expect(
            abs(
                result.innerSurfaceHeatFlux
                - 2
            ) < tolerance
        )

        #expect(
            abs(
                result.outerSurfaceHeatFlux
                - 0.5
            ) < tolerance
        )
    }

    @Test("Returns zero at equal temperatures")
    func returnsZeroAtEqualTemperatures()
        throws {

        let result = try engine.calculate(
            input:
                SphericalWallConductionInput(
                    thermalConductivity: 15,
                    innerRadius: 0.05,
                    outerRadius: 0.1,
                    innerSurfaceTemperature: 50,
                    outerSurfaceTemperature: 50
                )
        )

        #expect(
            abs(result.heatTransferRate)
                < tolerance
        )

        #expect(
            abs(result.innerSurfaceHeatFlux)
                < tolerance
        )
    }

    @Test("Rejects invalid spherical inputs")
    func rejectsInvalidInputs() {

        #expect(
            throws:
                SphericalWallConductionError
                    .nonPositiveThermalConductivity
        ) {
            try engine.calculate(
                input:
                    SphericalWallConductionInput(
                        thermalConductivity: 0,
                        innerRadius: 1,
                        outerRadius: 2,
                        innerSurfaceTemperature: 1,
                        outerSurfaceTemperature: 0
                    )
            )
        }

        #expect(
            throws:
                SphericalWallConductionError
                    .invalidOuterRadius
        ) {
            try engine.calculate(
                input:
                    SphericalWallConductionInput(
                        thermalConductivity: 1,
                        innerRadius: 2,
                        outerRadius: 1,
                        innerSurfaceTemperature: 1,
                        outerSurfaceTemperature: 0
                    )
            )
        }

        #expect(
            throws:
                SphericalWallConductionError
                    .invalidTemperatureOrder
        ) {
            try engine.calculate(
                input:
                    SphericalWallConductionInput(
                        thermalConductivity: 1,
                        innerRadius: 1,
                        outerRadius: 2,
                        innerSurfaceTemperature: 0,
                        outerSurfaceTemperature: 1
                    )
            )
        }
    }
}
