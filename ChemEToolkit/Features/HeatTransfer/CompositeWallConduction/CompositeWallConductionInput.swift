import Foundation

struct CompositeWallLayer:
    Equatable,
    Sendable {

    let name: String
    let thermalConductivity: Double
    let thickness: Double
}

struct CompositeWallConductionInput:
    Equatable,
    Sendable {

    let area: Double
    let hotSideTemperature: Double
    let coldSideTemperature: Double
    let layers: [CompositeWallLayer]
}
