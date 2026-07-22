import Foundation

enum IonExchangeBedSizingError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case invalidIonCharge
    case removalFractionOutOfRange
    case utilizationFractionOutOfRange
    case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All ion-exchange inputs must be finite."

        case .nonPositiveProperty:
            return """
            Liquid flow, influent concentration, service time and \
            resin capacity must be greater than zero.
            """

        case .invalidIonCharge:
            return "Ion charge magnitude must be a whole number from 1 through 6."

        case .removalFractionOutOfRange:
            return "Target removal fraction must satisfy 0 < removal ≤ 1."

        case .utilizationFractionOutOfRange:
            return "Capacity utilization fraction must satisfy 0 < utilization ≤ 1."

        case .numericalFailure:
            return "The ion-exchange sizing calculation did not produce finite physical results."
        }
    }
}
