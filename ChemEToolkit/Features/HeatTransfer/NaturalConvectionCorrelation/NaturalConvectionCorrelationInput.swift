import Foundation

enum NaturalConvectionGeometry:
    String,
    CaseIterable,
    Identifiable,
    Hashable,
    Sendable {

    case verticalPlate
    case horizontalCylinder

    var id: String { rawValue }

    var title: String {
        switch self {
        case .verticalPlate:
            return "Vertical Plate"
        case .horizontalCylinder:
            return "Horizontal Cylinder"
        }
    }
}

struct NaturalConvectionCorrelationInput:
    Equatable,
    Sendable {

    let geometry: NaturalConvectionGeometry
    let rayleighNumber: Double
    let prandtlNumber: Double
    let fluidThermalConductivity: Double
    let characteristicLength: Double
}
