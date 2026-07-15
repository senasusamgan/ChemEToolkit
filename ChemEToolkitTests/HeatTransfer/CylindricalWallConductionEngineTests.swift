import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Cylindrical Wall Conduction Engine")
struct CylindricalWallConductionEngineTests {

    private let engine =
        CylindricalWallConductionEngine()

    private let tolerance =
        0.000001

    @Test(
        "Calculates radial conduction through a cylinder"
    )
    func calculatesCylindricalWallConduction()
        throws {

        let input =
            CylindricalWallConductionInput(
                thermalConductivity: 1,
                innerRadius: 1,
                outerRadius: exp(1),
                cylinderLength: 1,
                innerSurfaceTemperature: 101,
                outerSurfaceTemperature: 100
            )

        let result =
            try engine.calculate(
                input: input
            )

        let expectedResistance =
            1
            / (
                2
                * Double.pi
            )

        let expectedHeatTransferRate =
            2
            * Double.pi

        #expect(
            abs(
                result.temperatureDifference
                - 1
            ) < tolerance
        )

        #expect(
            abs(
                result.thermalResistance
                - expectedResistance
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferRate
                - expectedHeatTransferRate
            ) < tolerance
        )

        #expect(
            abs(
                result.innerSurfaceArea
                - 2 * Double.pi
            ) < tolerance
        )

        #expect(
            abs(
                result.innerSurfaceHeatFlux
                - 1
            ) < tolerance
        )

        #expect(
            abs(
                result.outerSurfaceHeatFlux
                - 1 / exp(1)
            ) < tolerance
        )
    }

    @Test(
        "Returns zero radial heat transfer at equal temperatures"
    )
    func returnsZeroAtEqualTemperatures()
        throws {

        let input =
            CylindricalWallConductionInput(
                thermalConductivity: 15,
                innerRadius: 0.05,
                outerRadius: 0.1,
                cylinderLength: 2,
                innerSurfaceTemperature: 40,
                outerSurfaceTemperature: 40
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
            abs(result.innerSurfaceHeatFlux)
                < tolerance
        )

        #expect(
            abs(result.outerSurfaceHeatFlux)
                < tolerance
        )

        #expect(
            result.thermalResistance > 0
        )
    }

    @Test(
        "Rejects invalid cylindrical geometry and properties"
    )
    func rejectsInvalidCylindricalInputs() {

        #expect(
            throws:
                CylindricalWallConductionError
                    .nonPositiveThermalConductivity
        ) {
            try engine.calculate(
                input:
                    CylindricalWallConductionInput(
                        thermalConductivity: 0,
                        innerRadius: 0.05,
                        outerRadius: 0.1,
                        cylinderLength: 2,
                        innerSurfaceTemperature: 100,
                        outerSurfaceTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                CylindricalWallConductionError
                    .nonPositiveInnerRadius
        ) {
            try engine.calculate(
                input:
                    CylindricalWallConductionInput(
                        thermalConductivity: 15,
                        innerRadius: 0,
                        outerRadius: 0.1,
                        cylinderLength: 2,
                        innerSurfaceTemperature: 100,
                        outerSurfaceTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                CylindricalWallConductionError
                    .invalidOuterRadius
        ) {
            try engine.calculate(
                input:
                    CylindricalWallConductionInput(
                        thermalConductivity: 15,
                        innerRadius: 0.1,
                        outerRadius: 0.05,
                        cylinderLength: 2,
                        innerSurfaceTemperature: 100,
                        outerSurfaceTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                CylindricalWallConductionError
                    .nonPositiveCylinderLength
        ) {
            try engine.calculate(
                input:
                    CylindricalWallConductionInput(
                        thermalConductivity: 15,
                        innerRadius: 0.05,
                        outerRadius: 0.1,
                        cylinderLength: 0,
                        innerSurfaceTemperature: 100,
                        outerSurfaceTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                CylindricalWallConductionError
                    .invalidTemperatureOrder
        ) {
            try engine.calculate(
                input:
                    CylindricalWallConductionInput(
                        thermalConductivity: 15,
                        innerRadius: 0.05,
                        outerRadius: 0.1,
                        cylinderLength: 2,
                        innerSurfaceTemperature: 20,
                        outerSurfaceTemperature: 100
                    )
            )
        }
    }
}
