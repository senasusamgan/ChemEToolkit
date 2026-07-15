import Foundation

enum BoilingRegimeIndicator:
    Equatable,
    Sendable {

    case noBoiling
    case boilingPossible

    var title: String {
        switch self {
        case .noBoiling:
            return "No positive wall superheat"
        case .boilingPossible:
            return "Positive wall superheat"
        }
    }
}

struct BoilingHeatTransferResult:
    Equatable,
    Sendable {

    let wallSuperheat: Double
    let heatFlux: Double
    let heatTransferRate: Double
    let regimeIndicator: BoilingRegimeIndicator
}
