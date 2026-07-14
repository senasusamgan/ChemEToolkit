import Foundation

struct IdealGasEngine {
    static let gasConstant = 8.314462618

    func solve(
        unknownVariable: GasVariable,
        input: IdealGasInput
    ) throws -> IdealGasResult {
        let calculatedValue: Double

        switch unknownVariable {
        case .pressure:
            let volume = try requiredPositiveValue(
                input.volume,
                variable: .volume
            )

            let moles = try requiredPositiveValue(
                input.moles,
                variable: .moles
            )

            let temperature = try requiredPositiveValue(
                input.temperature,
                variable: .temperature
            )

            calculatedValue =
                moles *
                Self.gasConstant *
                temperature /
                volume

        case .volume:
            let pressure = try requiredPositiveValue(
                input.pressure,
                variable: .pressure
            )

            let moles = try requiredPositiveValue(
                input.moles,
                variable: .moles
            )

            let temperature = try requiredPositiveValue(
                input.temperature,
                variable: .temperature
            )

            calculatedValue =
                moles *
                Self.gasConstant *
                temperature /
                pressure

        case .moles:
            let pressure = try requiredPositiveValue(
                input.pressure,
                variable: .pressure
            )

            let volume = try requiredPositiveValue(
                input.volume,
                variable: .volume
            )

            let temperature = try requiredPositiveValue(
                input.temperature,
                variable: .temperature
            )

            calculatedValue =
                pressure *
                volume /
                (
                    Self.gasConstant *
                    temperature
                )

        case .temperature:
            let pressure = try requiredPositiveValue(
                input.pressure,
                variable: .pressure
            )

            let volume = try requiredPositiveValue(
                input.volume,
                variable: .volume
            )

            let moles = try requiredPositiveValue(
                input.moles,
                variable: .moles
            )

            calculatedValue =
                pressure *
                volume /
                (
                    moles *
                    Self.gasConstant
                )
        }

        let validatedResult =
            try InputValidator.validateResult(
                calculatedValue
            )

        return IdealGasResult(
            variable: unknownVariable,
            value: validatedResult
        )
    }

    private func requiredPositiveValue(
        _ value: Double?,
        variable: GasVariable
    ) throws -> Double {
        guard let value else {
            throw CalculationError.emptyField(
                fieldName: variable.name
            )
        }

        return try InputValidator.requirePositive(
            value,
            fieldName: variable.name
        )
    }
}
