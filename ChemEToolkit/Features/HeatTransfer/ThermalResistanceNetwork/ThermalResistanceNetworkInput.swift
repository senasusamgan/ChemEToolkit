import Foundation

enum ThermalResistanceArrangement:
    String,
    CaseIterable,
    Identifiable,
    Hashable,
    Sendable {

    case series
    case parallel

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .series:
            return "Series"

        case .parallel:
            return "Parallel"
        }
    }
}

struct ThermalResistanceNetworkInput:
    Equatable,
    Sendable {

    let arrangement:
        ThermalResistanceArrangement

    let hotSideTemperature: Double
    let coldSideTemperature: Double

    let resistances: [Double]
}
