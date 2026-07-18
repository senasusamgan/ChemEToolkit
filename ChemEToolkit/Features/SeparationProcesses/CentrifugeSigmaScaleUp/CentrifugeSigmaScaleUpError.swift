import Foundation

enum CentrifugeSigmaScaleUpError: Error, Equatable, LocalizedError {
    case nonFiniteInput
case nonPositiveThroughputOrSigma
case invalidCorrection
case numericalFailure

    var errorDescription: String? {
        switch self {
        case .nonFiniteInput: return "Throughput, sigma factors and correction must be finite."
    case .nonPositiveThroughputOrSigma: return "Reference throughput and both sigma factors must be greater than zero."
    case .invalidCorrection: return "Efficiency correction must be greater than zero and no greater than one."
    case .numericalFailure: return "The centrifuge scale-up calculation did not produce finite results."
        }
    }
}
