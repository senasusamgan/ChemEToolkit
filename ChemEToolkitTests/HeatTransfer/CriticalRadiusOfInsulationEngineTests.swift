import Foundation
import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Critical Radius of Insulation Engine")
struct CriticalRadiusOfInsulationEngineTests {

    private let engine =
        CriticalRadiusOfInsulationEngine()

    private let tolerance =
        0.000001

    @Test(
        "Calculates heat transfer below the critical radius"
    )
    func calculatesBelowCriticalRadius()
        throws {

        let input =
            CriticalRadiusOfInsulationInput(
                insulationThermalConductivity: 0.05,
                externalHeatTransferCoefficient: 10,
                innerRadius: 0.002,
                outerRadius: 0.004,
                cylinderLength: 1,
                innerSurfaceTemperature: 100,
                ambientTemperature: 20
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.criticalRadius
                - 0.005
            ) < tolerance
        )

        #expect(
            abs(
                result.conductionResistance
                - 2.206356001526516
            ) < tolerance
        )

        #expect(
            abs(
                result.convectionResistance
                - 3.9788735772973833
            ) < tolerance
        )

        #expect(
            abs(
                result.currentHeatTransferRate
                - 12.934038903566735
            ) < tolerance
        )

        #expect(
            abs(
                result.maximumHeatTransferRate
                - 13.115306989006948
            ) < tolerance
        )

        #expect(
            result.regime
                == .belowCriticalRadius
        )
    }

    @Test(
        "Recognizes when critical radius is inside the original surface"
    )
    func recognizesAlwaysReducingRegime()
        throws {

        let input =
            CriticalRadiusOfInsulationInput(
                insulationThermalConductivity: 0.02,
                externalHeatTransferCoefficient: 20,
                innerRadius: 0.01,
                outerRadius: 0.02,
                cylinderLength: 1,
                innerSurfaceTemperature: 100,
                ambientTemperature: 20
            )

        let result =
            try engine.calculate(input: input)

        #expect(
            abs(
                result.criticalRadius
                - 0.001
            ) < tolerance
        )

        #expect(
            abs(
                result.maximumHeatTransferRadius
                - 0.01
            ) < tolerance
        )

        #expect(
            result.regime
                == .criticalRadiusInsideOriginalSurface
        )

        #expect(
            result.currentHeatTransferRate
                < result.maximumHeatTransferRate
        )
    }

    @Test(
        "Rejects invalid cylindrical insulation inputs"
    )
    func rejectsInvalidInputs() {

        #expect(
            throws:
                CriticalRadiusOfInsulationError
                    .nonPositiveThermalConductivity
        ) {
            try engine.calculate(
                input:
                    CriticalRadiusOfInsulationInput(
                        insulationThermalConductivity: 0,
                        externalHeatTransferCoefficient: 10,
                        innerRadius: 0.002,
                        outerRadius: 0.004,
                        cylinderLength: 1,
                        innerSurfaceTemperature: 100,
                        ambientTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                CriticalRadiusOfInsulationError
                    .invalidOuterRadius
        ) {
            try engine.calculate(
                input:
                    CriticalRadiusOfInsulationInput(
                        insulationThermalConductivity: 0.05,
                        externalHeatTransferCoefficient: 10,
                        innerRadius: 0.01,
                        outerRadius: 0.005,
                        cylinderLength: 1,
                        innerSurfaceTemperature: 100,
                        ambientTemperature: 20
                    )
            )
        }

        #expect(
            throws:
                CriticalRadiusOfInsulationError
                    .invalidTemperatureOrder
        ) {
            try engine.calculate(
                input:
                    CriticalRadiusOfInsulationInput(
                        insulationThermalConductivity: 0.05,
                        externalHeatTransferCoefficient: 10,
                        innerRadius: 0.002,
                        outerRadius: 0.004,
                        cylinderLength: 1,
                        innerSurfaceTemperature: 20,
                        ambientTemperature: 100
                    )
            )
        }
    }
}
