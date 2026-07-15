import Foundation

enum ForcedConvectionCorrelationUsed:
    Equatable,
    Sendable {

    case dittusBoelter
    case siederTateLaminar
    case flatPlateLaminar
    case flatPlateTurbulent

    var title: String {
        switch self {
        case .dittusBoelter:
            return "Dittus–Boelter"
        case .siederTateLaminar:
            return "Laminar Tube, Fully Developed"
        case .flatPlateLaminar:
            return "Flat Plate, Laminar"
        case .flatPlateTurbulent:
            return "Flat Plate, Turbulent"
        }
    }
}

struct ForcedConvectionCorrelationResult:
    Equatable,
    Sendable {

    let nusseltNumber: Double
    let heatTransferCoefficient: Double
    let correlationUsed: ForcedConvectionCorrelationUsed
}
