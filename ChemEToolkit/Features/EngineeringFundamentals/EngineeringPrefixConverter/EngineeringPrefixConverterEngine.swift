import Foundation

struct EngineeringPrefixConverterEngine:
    Sendable {

    private let prefixNames: [Int: String] = [
        -12: "pico",
        -9: "nano",
        -6: "micro",
        -3: "milli",
        0: "base unit",
        3: "kilo",
        6: "mega",
        9: "giga",
        12: "tera"
    ]

    func calculate(
        _ input:
            EngineeringPrefixConverterInput
    ) throws
        -> EngineeringPrefixConverterResult {

        let values = [
            input.enteredValue,
            input.inputPowerOfTen,
            input.outputPowerOfTen
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EngineeringPrefixConverterError
                .nonFiniteInput
        }

        let roundedInput =
            input.inputPowerOfTen.rounded()

        let roundedOutput =
            input.outputPowerOfTen.rounded()

        let inputPower =
            Int(roundedInput)

        let outputPower =
            Int(roundedOutput)

        guard
            abs(
                input.inputPowerOfTen
                - roundedInput
            ) < 1e-12,
            abs(
                input.outputPowerOfTen
                - roundedOutput
            ) < 1e-12,
            prefixNames[inputPower] != nil,
            prefixNames[outputPower] != nil
        else {
            throw EngineeringPrefixConverterError
                .invalidPowerOfTen
        }

        let exponentDifference =
            inputPower
            - outputPower

        let factor =
            Foundation.pow(
                10,
                Double(exponentDifference)
            )

        let converted =
            input.enteredValue
            * factor

        guard
            factor.isFinite,
            converted.isFinite
        else {
            throw EngineeringPrefixConverterError
                .numericalFailure
        }

        return .init(
            convertedValue:
                converted,
            conversionFactor:
                factor,
            inputPowerOfTen:
                inputPower,
            outputPowerOfTen:
                outputPower,
            inputPrefixName:
                prefixNames[inputPower]
                ?? "unknown",
            outputPrefixName:
                prefixNames[outputPower]
                ?? "unknown",
            modelName:
                "Engineering-prefix power-of-ten conversion",
            limitationDescription:
                "Use powers −12, −9, −6, −3, 0, 3, 6, 9 or 12. The physical unit itself remains unchanged."
        )
    }
}
