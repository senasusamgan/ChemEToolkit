import Foundation

struct ConcentrationEngine {
    func solve(
        mode: ConcentrationMode,
        unknownVariable: ConcentrationUnknown,
        input: ConcentrationInput
    ) throws -> ConcentrationResult {
        let calculatedValue: Double

        switch unknownVariable {
        case .concentration:
            let moles = try requiredNonNegativeValue(
                input.moles,
                fieldName: "Amount of Solute"
            )

            let denominator = try requiredPositiveValue(
                input.denominator,
                fieldName: mode.denominatorName
            )

            calculatedValue = moles / denominator

        case .moles:
            let concentration = try requiredNonNegativeValue(
                input.concentration,
                fieldName: mode.title
            )

            let denominator = try requiredPositiveValue(
                input.denominator,
                fieldName: mode.denominatorName
            )

            calculatedValue =
                concentration * denominator

        case .denominator:
            let concentration = try requiredPositiveValue(
                input.concentration,
                fieldName: mode.title
            )

            let moles = try requiredNonNegativeValue(
                input.moles,
                fieldName: "Amount of Solute"
            )

            calculatedValue = moles / concentration
        }

        let validatedResult =
            try InputValidator.validateResult(
                calculatedValue
            )

        return ConcentrationResult(
            mode: mode,
            variable: unknownVariable,
            value: validatedResult
        )
    }

    private func requiredPositiveValue(
        _ value: Double?,
        fieldName: String
    ) throws -> Double {
        guard let value else {
            throw CalculationError.emptyField(
                fieldName: fieldName
            )
        }

        return try InputValidator.requirePositive(
            value,
            fieldName: fieldName
        )
    }

    private func requiredNonNegativeValue(
        _ value: Double?,
        fieldName: String
    ) throws -> Double {
        guard let value else {
            throw CalculationError.emptyField(
                fieldName: fieldName
            )
        }

        return try InputValidator.requireNonNegative(
            value,
            fieldName: fieldName
        )
    }
}
