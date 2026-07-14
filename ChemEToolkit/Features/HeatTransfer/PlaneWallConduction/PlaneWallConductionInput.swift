import Foundation

struct PlaneWallConductionInput:
    Equatable,
    Sendable {

    let thermalConductivity: Double
    let area: Double
    let wallThickness: Double
    let hotSideTemperature: Double
    let coldSideTemperature: Double
}
