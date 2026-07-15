import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Fourier Number Engine")
struct FourierNumberEngineTests {

    private let engine = FourierNumberEngine()
    private let tolerance = 0.000001

    @Test("Calculates dimensionless diffusion time")
    func calculatesFourierNumber() throws {
        let result = try engine.calculate(
            input: FourierNumberInput(
                thermalDiffusivity: 0.00001,
                elapsedTime: 3600,
                characteristicLength: 0.1
            )
        )

        #expect(
            abs(result.fourierNumber - 3.6)
                < tolerance
        )

        #expect(
            abs(
                result.thermalDiffusionLength
                - 0.18973665961010275
            ) < tolerance
        )

        #expect(
            abs(
                result.normalizedDiffusionLength
                - 1.8973665961010275
            ) < tolerance
        )
    }

    @Test("Returns zero at initial time")
    func returnsZeroAtInitialTime() throws {
        let result = try engine.calculate(
            input: FourierNumberInput(
                thermalDiffusivity: 0.00001,
                elapsedTime: 0,
                characteristicLength: 0.1
            )
        )

        #expect(
            abs(result.fourierNumber)
                < tolerance
        )

        #expect(
            abs(result.thermalDiffusionLength)
                < tolerance
        )
    }

    @Test("Rejects invalid Fourier inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                FourierNumberError
                    .nonPositiveThermalDiffusivity
        ) {
            try engine.calculate(
                input: FourierNumberInput(
                    thermalDiffusivity: 0,
                    elapsedTime: 1,
                    characteristicLength: 0.1
                )
            )
        }

        #expect(
            throws:
                FourierNumberError
                    .negativeElapsedTime
        ) {
            try engine.calculate(
                input: FourierNumberInput(
                    thermalDiffusivity: 0.00001,
                    elapsedTime: -1,
                    characteristicLength: 0.1
                )
            )
        }

        #expect(
            throws:
                FourierNumberError
                    .nonPositiveCharacteristicLength
        ) {
            try engine.calculate(
                input: FourierNumberInput(
                    thermalDiffusivity: 0.00001,
                    elapsedTime: 1,
                    characteristicLength: 0
                )
            )
        }
    }
}
