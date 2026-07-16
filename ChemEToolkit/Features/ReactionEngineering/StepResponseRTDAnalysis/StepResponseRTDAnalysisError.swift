import Foundation

enum StepResponseRTDAnalysisError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case mismatchedArrays
    case insufficientData
    case negativeTime
    case nonIncreasingTime
    case responseOutOfRange
    case nonMonotonicResponse
    case incompleteResponse
    case medianNotResolved
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All step-response time and normalized outlet values must be finite."
        case .mismatchedArrays:
            return "Time and normalized outlet-response arrays must contain the same number of values."
        case .insufficientData:
            return "At least two step-response measurements are required."
        case .negativeTime:
            return "Step-response times cannot be negative."
        case .nonIncreasingTime:
            return "Step-response time values must be strictly increasing."
        case .responseOutOfRange:
            return "Normalized step-response values must satisfy 0 ≤ F ≤ 1."
        case .nonMonotonicResponse:
            return "Normalized step-response values must be nondecreasing."
        case .incompleteResponse:
            return "The final normalized response must be at least 0.95 for RTD statistics."
        case .medianNotResolved:
            return "The supplied step-response data do not resolve the median residence time."
        case .numericalFailure:
            return "The step-response RTD calculation did not produce finite physical results."
        }
    }
}
