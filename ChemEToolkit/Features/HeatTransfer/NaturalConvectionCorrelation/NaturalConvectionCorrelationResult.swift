import Foundation

enum NaturalConvectionCorrelationUsed:
    Equatable,
    Sendable {

    case churchillChuVerticalPlate
    case churchillChuHorizontalCylinder

    var title: String {
        switch self {
        case .churchillChuVerticalPlate:
            return "Churchill–Chu Vertical Plate"
        case .churchillChuHorizontalCylinder:
            return "Churchill–Chu Horizontal Cylinder"
        }
    }
}

struct NaturalConvectionCorrelationResult:
    Equatable,
    Sendable {

    let nusseltNumber: Double
    let heatTransferCoefficient: Double
    let correlationUsed:
        NaturalConvectionCorrelationUsed
}
