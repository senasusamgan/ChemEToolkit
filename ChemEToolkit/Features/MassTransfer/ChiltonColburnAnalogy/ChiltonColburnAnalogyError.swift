import Foundation

enum ChiltonColburnAnalogyError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case reynoldsOutOfRange
    case schmidtOutOfRange

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inputs must be finite."

        case .nonPositiveProperty:
            return """
            Fanning friction factor, Reynolds number, \
            Schmidt number and average velocity must \
            be greater than zero.
            """

        case .reynoldsOutOfRange:
            return """
            Reynolds number must be at least 10000 \
            for the implemented turbulent-flow analogy.
            """

        case .schmidtOutOfRange:
            return """
            Schmidt number must be between 0.6 and \
            3000 for the implemented analogy.
            """
        }
    }
}
