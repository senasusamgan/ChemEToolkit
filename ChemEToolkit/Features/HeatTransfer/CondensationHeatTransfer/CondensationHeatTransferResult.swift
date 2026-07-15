import Foundation

enum CondensationRegimeIndicator:
    Equatable,
    Sendable {

    case noCondensation
    case condensationPossible

    var title: String {
        switch self {
        case .noCondensation:
            return "No positive vapor-to-wall temperature difference"
        case .condensationPossible:
            return "Condensation temperature difference present"
        }
    }
}

struct CondensationHeatTransferResult:
    Equatable,
    Sendable {

    let temperatureDifference: Double
    let heatFlux: Double
    let heatTransferRate: Double
    let regimeIndicator:
        CondensationRegimeIndicator
}
