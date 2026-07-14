import Foundation

struct UnitConverterEngine {
    func convert(
        value: Double,
        from fromUnit: ConversionUnit,
        to toUnit: ConversionUnit
    ) throws -> UnitConversionResult {
        guard value.isFinite else {
            throw CalculationError.invalidNumber(
                fieldName: "Value"
            )
        }

        guard fromUnit.category == toUnit.category else {
            throw CalculationError.calculationFailed(
                reason: "Units from different categories cannot be converted."
            )
        }

        let outputValue: Double

        if fromUnit.category == .temperature {
            outputValue = try convertTemperature(
                value: value,
                from: fromUnit,
                to: toUnit
            )
        } else {
            outputValue = try convertLinear(
                value: value,
                from: fromUnit,
                to: toUnit
            )
        }

        let validatedOutput =
            try InputValidator.validateResult(
                outputValue
            )

        return UnitConversionResult(
            inputValue: value,
            outputValue: validatedOutput,
            fromUnit: fromUnit,
            toUnit: toUnit
        )
    }

    private func convertLinear(
        value: Double,
        from fromUnit: ConversionUnit,
        to toUnit: ConversionUnit
    ) throws -> Double {
        guard
            let fromFactor =
                fromUnit.linearFactorToBaseUnit,
            let toFactor =
                toUnit.linearFactorToBaseUnit
        else {
            throw CalculationError.calculationFailed(
                reason: "The selected unit is not supported."
            )
        }

        let baseValue = value * fromFactor

        return baseValue / toFactor
    }

    private func convertTemperature(
        value: Double,
        from fromUnit: ConversionUnit,
        to toUnit: ConversionUnit
    ) throws -> Double {
        let valueInKelvin: Double

        switch fromUnit {
        case .celsius:
            valueInKelvin = value + 273.15

        case .kelvin:
            valueInKelvin = value

        case .fahrenheit:
            valueInKelvin =
                (value - 32) * 5 / 9 + 273.15

        default:
            throw CalculationError.calculationFailed(
                reason: "The selected temperature unit is not supported."
            )
        }

        switch toUnit {
        case .celsius:
            return valueInKelvin - 273.15

        case .kelvin:
            return valueInKelvin

        case .fahrenheit:
            return
                (valueInKelvin - 273.15) *
                9 / 5 + 32

        default:
            throw CalculationError.calculationFailed(
                reason: "The selected temperature unit is not supported."
            )
        }
    }
}
