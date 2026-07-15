import Foundation

struct ThermalRadiationInput:
    Equatable,
    Sendable {

    /// Surface emissivity, 0...1.
    let emissivity: Double

    /// Radiating surface area, m².
    let area: Double

    /// Surface temperature, °C.
    let surfaceTemperature: Double

    /// Large-surroundings temperature, °C.
    let surroundingsTemperature: Double
}
