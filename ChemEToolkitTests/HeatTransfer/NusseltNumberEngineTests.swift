import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Nusselt Number Engine")
struct NusseltNumberEngineTests {

    private let engine = NusseltNumberEngine()
    private let tolerance = 0.000001

    @Test("Calculates convection enhancement")
    func calculatesNusseltNumber() throws {
        let result = try engine.calculate(
            input: NusseltNumberInput(
                heatTransferCoefficient: 100,
                characteristicLength: 0.05,
                fluidThermalConductivity: 0.6
            )
        )

        #expect(
            abs(
                result.nusseltNumber
                - 8.333333333333334
            ) < tolerance
        )

        #expect(
            abs(
                result.referenceConductionCoefficient
                - 12
            ) < tolerance
        )

        #expect(
            result.transportRegime
                == .convectionEnhanced
        )
    }

    @Test("Recognizes unity Nusselt number")
    func recognizesUnity() throws {
        let result = try engine.calculate(
            input: NusseltNumberInput(
                heatTransferCoefficient: 10,
                characteristicLength: 0.1,
                fluidThermalConductivity: 1
            )
        )

        #expect(
            abs(result.nusseltNumber - 1)
                < tolerance
        )

        #expect(
            result.transportRegime
                == .approximatelyUnity
        )
    }

    @Test("Rejects invalid Nusselt inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                NusseltNumberError
                    .nonPositiveHeatTransferCoefficient
        ) {
            try engine.calculate(
                input: NusseltNumberInput(
                    heatTransferCoefficient: 0,
                    characteristicLength: 0.1,
                    fluidThermalConductivity: 1
                )
            )
        }

        #expect(
            throws:
                NusseltNumberError
                    .nonPositiveCharacteristicLength
        ) {
            try engine.calculate(
                input: NusseltNumberInput(
                    heatTransferCoefficient: 10,
                    characteristicLength: 0,
                    fluidThermalConductivity: 1
                )
            )
        }

        #expect(
            throws:
                NusseltNumberError
                    .nonPositiveThermalConductivity
        ) {
            try engine.calculate(
                input: NusseltNumberInput(
                    heatTransferCoefficient: 10,
                    characteristicLength: 0.1,
                    fluidThermalConductivity: 0
                )
            )
        }
    }
}
