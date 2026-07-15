import Foundation

enum ConvectiveMassTransferCorrelationsError:
    Error,
    Equatable,
    LocalizedError {

    case nonFiniteInput
    case nonPositiveProperty
    case reynoldsOutOfRange(
        minimumExclusive: Double?,
        minimumInclusive: Double?,
        maximumInclusive: Double
    )
    case schmidtOutOfRange

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput:
            return "All inputs must be finite."

        case .nonPositiveProperty:
            return """
            Reynolds number, Schmidt number, \
            diffusivity and characteristic length \
            must be greater than zero.
            """

        case .reynoldsOutOfRange(
            let minimumExclusive,
            let minimumInclusive,
            let maximumInclusive
        ):
            if let minimumExclusive {
                return """
                Reynolds number must be greater than \
                \(minimumExclusive) and no greater than \
                \(maximumInclusive) for the selected correlation.
                """
            }

            return """
            Reynolds number must be at least \
            \(minimumInclusive ?? 0) and no greater than \
            \(maximumInclusive) for the selected correlation.
            """

        case .schmidtOutOfRange:
            return """
            Schmidt number must be between \
            0.6 and 3000 for the selected correlation.
            """
        }
    }
}
