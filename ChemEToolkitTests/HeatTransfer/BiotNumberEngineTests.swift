import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Biot Number Engine")
struct BiotNumberEngineTests {

    private let engine = BiotNumberEngine()
    private let tolerance = 0.000001

    @Test("Calculates Biot number and lumped criterion")
    func calculatesBiotNumber() throws {
        let result = try engine.calculate(
            input: BiotNumberInput(
                heatTransferCoefficient: 100,
                characteristicLength: 0.01,
                solidThermalConductivity: 50
            )
        )

        #expect(
            abs(result.biotNumber - 0.02)
                < tolerance
        )

        #expect(
            abs(
                result.internalConductionScale
                - 5_000
            ) < tolerance
        )

        #expect(
            result.lumpedCapacitanceUsuallyValid
        )
    }

    @Test("Treats Bi equals 0.1 as outside strict criterion")
    func checksStrictCriterion() throws {
        let result = try engine.calculate(
            input: BiotNumberInput(
                heatTransferCoefficient: 10,
                characteristicLength: 0.01,
                solidThermalConductivity: 1
            )
        )

        #expect(
            abs(result.biotNumber - 0.1)
                < tolerance
        )

        #expect(
            !result.lumpedCapacitanceUsuallyValid
        )
    }

    @Test("Rejects invalid Biot inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                BiotNumberError
                    .nonPositiveHeatTransferCoefficient
        ) {
            try engine.calculate(
                input: BiotNumberInput(
                    heatTransferCoefficient: 0,
                    characteristicLength: 0.01,
                    solidThermalConductivity: 50
                )
            )
        }

        #expect(
            throws:
                BiotNumberError
                    .nonPositiveCharacteristicLength
        ) {
            try engine.calculate(
                input: BiotNumberInput(
                    heatTransferCoefficient: 100,
                    characteristicLength: 0,
                    solidThermalConductivity: 50
                )
            )
        }

        #expect(
            throws:
                BiotNumberError
                    .nonPositiveSolidThermalConductivity
        ) {
            try engine.calculate(
                input: BiotNumberInput(
                    heatTransferCoefficient: 100,
                    characteristicLength: 0.01,
                    solidThermalConductivity: 0
                )
            )
        }
    }
}
