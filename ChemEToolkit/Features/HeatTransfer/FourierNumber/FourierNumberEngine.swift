import Foundation

struct FourierNumberEngine {

    func calculate(
        input: FourierNumberInput
    ) throws -> FourierNumberResult {

        try validate(input)

        let thermalDiffusionLength =
            sqrt(
                input.thermalDiffusivity
                * input.elapsedTime
            )

        let fourierNumber =
            input.thermalDiffusivity
            * input.elapsedTime
            / pow(
                input.characteristicLength,
                2
            )

        return FourierNumberResult(
            fourierNumber: fourierNumber,
            thermalDiffusionLength:
                thermalDiffusionLength,
            normalizedDiffusionLength:
                sqrt(fourierNumber)
        )
    }

    private func validate(
        _ input: FourierNumberInput
    ) throws {

        let values = [
            input.thermalDiffusivity,
            input.elapsedTime,
            input.characteristicLength
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FourierNumberError.nonFiniteInput
        }

        guard input.thermalDiffusivity > 0 else {
            throw FourierNumberError
                .nonPositiveThermalDiffusivity
        }

        guard input.elapsedTime >= 0 else {
            throw FourierNumberError
                .negativeElapsedTime
        }

        guard input.characteristicLength > 0 else {
            throw FourierNumberError
                .nonPositiveCharacteristicLength
        }
    }
}
