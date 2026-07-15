import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Forced Convection Correlation Engine")
struct ForcedConvectionCorrelationEngineTests {

    private let engine =
        ForcedConvectionCorrelationEngine()

    private let tolerance = 0.000001

    @Test("Calculates Dittus-Boelter tube convection")
    func calculatesDittusBoelter() throws {
        let result = try engine.calculate(
            input:
                ForcedConvectionCorrelationInput(
                    geometry:
                        .internalCircularTube,
                    reynoldsNumber: 100_000,
                    prandtlNumber: 1,
                    fluidThermalConductivity: 0.6,
                    characteristicLength: 0.02
                )
        )

        #expect(
            abs(
                result.nusseltNumber
                - 230
            ) < tolerance
        )

        #expect(
            abs(
                result.heatTransferCoefficient
                - 6_900
            ) < tolerance
        )

        #expect(
            result.correlationUsed
                == .dittusBoelter
        )
    }

    @Test("Calculates laminar flat-plate convection")
    func calculatesFlatPlateLaminar() throws {
        let result = try engine.calculate(
            input:
                ForcedConvectionCorrelationInput(
                    geometry: .externalFlatPlate,
                    reynoldsNumber: 10_000,
                    prandtlNumber: 1,
                    fluidThermalConductivity: 1,
                    characteristicLength: 1
                )
        )

        #expect(
            abs(result.nusseltNumber - 66.4)
                < tolerance
        )

        #expect(
            result.correlationUsed
                == .flatPlateLaminar
        )
    }

    @Test("Rejects unsupported or invalid inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                ForcedConvectionCorrelationError
                    .unsupportedRange
        ) {
            try engine.calculate(
                input:
                    ForcedConvectionCorrelationInput(
                        geometry:
                            .internalCircularTube,
                        reynoldsNumber: 5_000,
                        prandtlNumber: 1,
                        fluidThermalConductivity: 1,
                        characteristicLength: 1
                    )
            )
        }

        #expect(
            throws:
                ForcedConvectionCorrelationError
                    .nonPositiveCharacteristicLength
        ) {
            try engine.calculate(
                input:
                    ForcedConvectionCorrelationInput(
                        geometry:
                            .externalFlatPlate,
                        reynoldsNumber: 10_000,
                        prandtlNumber: 1,
                        fluidThermalConductivity: 1,
                        characteristicLength: 0
                    )
            )
        }
    }
}
