import Foundation

enum ForcedConvectionGeometry:
    String,
    CaseIterable,
    Identifiable,
    Hashable,
    Sendable {

    case internalCircularTube
    case externalFlatPlate

    var id: String { rawValue }

    var title: String {
        switch self {
        case .internalCircularTube:
            return "Internal Circular Tube"
        case .externalFlatPlate:
            return "External Flat Plate"
        }
    }
}

struct ForcedConvectionCorrelationInput:
    Equatable,
    Sendable {

    let geometry: ForcedConvectionGeometry
    let reynoldsNumber: Double
    let prandtlNumber: Double
    let fluidThermalConductivity: Double
    let characteristicLength: Double
}
