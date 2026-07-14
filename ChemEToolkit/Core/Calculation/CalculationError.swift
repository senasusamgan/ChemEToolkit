import Foundation

enum CalculationError: LocalizedError, Equatable {
    case emptyField(fieldName: String)
    case invalidNumber(fieldName: String)
    case valueMustBePositive(fieldName: String)
    case valueCannotBeNegative(fieldName: String)
    case valueCannotBeZero(fieldName: String)
    case valueOutOfRange(
        fieldName: String,
        minimum: Double,
        maximum: Double
    )
    case divisionByZero
    case nonFiniteResult
    case calculationFailed(reason: String)

    var errorDescription: String? {
        switch self {
        case .emptyField(let fieldName):
            return "\(fieldName) is required."

        case .invalidNumber(let fieldName):
            return "Enter a valid number for \(fieldName)."

        case .valueMustBePositive(let fieldName):
            return "\(fieldName) must be greater than zero."

        case .valueCannotBeNegative(let fieldName):
            return "\(fieldName) cannot be negative."

        case .valueCannotBeZero(let fieldName):
            return "\(fieldName) cannot be zero."

        case .valueOutOfRange(
            let fieldName,
            let minimum,
            let maximum
        ):
            return "\(fieldName) must be between \(minimum) and \(maximum)."

        case .divisionByZero:
            return "The calculation attempted to divide by zero."

        case .nonFiniteResult:
            return "The calculation produced an invalid result."

        case .calculationFailed(let reason):
            return reason
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .emptyField:
            return "Complete all required fields and try again."

        case .invalidNumber:
            return "Use numbers only. Decimal separators are supported."

        case .valueMustBePositive,
             .valueCannotBeNegative,
             .valueCannotBeZero,
             .valueOutOfRange:
            return "Check the entered value and its unit."

        case .divisionByZero:
            return "Check that denominator values are not zero."

        case .nonFiniteResult:
            return "Review the inputs and make sure they are physically meaningful."

        case .calculationFailed:
            return "Review the inputs and try again."
        }
    }
}
