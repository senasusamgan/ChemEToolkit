import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Natural Convection Correlation Engine")
struct NaturalConvectionCorrelationEngineTests {

    private let engine =
        NaturalConvectionCorrelationEngine()

    private let tolerance = 0.000001

    @Test("Calculates vertical-plate natural convection")
    func calculatesVerticalPlate() throws {
        let result = try engine.calculate(
            input:
                NaturalConvectionCorrelationInput(
                    geometry: .verticalPlate,
                    rayleighNumber: 1_000_000,
                    prandtlNumber: 1,
                    fluidThermalConductivity: 0.026,
                    characteristicLength: 0.5
                )
        )

        #expect(result.nusseltNumber > 0)
        #expect(
            result.heatTransferCoefficient > 0
        )
        #expect(
            result.correlationUsed
                == .churchillChuVerticalPlate
        )
    }

    @Test("Calculates horizontal-cylinder natural convection")
    func calculatesHorizontalCylinder() throws {
        let result = try engine.calculate(
            input:
                NaturalConvectionCorrelationInput(
                    geometry:
                        .horizontalCylinder,
                    rayleighNumber: 1_000_000,
                    prandtlNumber: 1,
                    fluidThermalConductivity: 0.026,
                    characteristicLength: 0.1
                )
        )

        #expect(result.nusseltNumber > 0)
        #expect(
            result.heatTransferCoefficient > 0
        )
        #expect(
            result.correlationUsed
                == .churchillChuHorizontalCylinder
        )
    }

    @Test("Rejects invalid natural-convection inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                NaturalConvectionCorrelationError
                    .nonPositiveRayleighNumber
        ) {
            try engine.calculate(
                input:
                    NaturalConvectionCorrelationInput(
                        geometry: .verticalPlate,
                        rayleighNumber: 0,
                        prandtlNumber: 1,
                        fluidThermalConductivity: 1,
                        characteristicLength: 1
                    )
            )
        }

        #expect(
            throws:
                NaturalConvectionCorrelationError
                    .nonPositivePrandtlNumber
        ) {
            try engine.calculate(
                input:
                    NaturalConvectionCorrelationInput(
                        geometry: .verticalPlate,
                        rayleighNumber: 1,
                        prandtlNumber: 0,
                        fluidThermalConductivity: 1,
                        characteristicLength: 1
                    )
            )
        }
    }
}
