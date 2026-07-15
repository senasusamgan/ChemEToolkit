import Foundation

struct CompositeWallLayerResult:
    Equatable,
    Sendable {

    let name: String

    /// Thermal resistance of the layer, K/W.
    let thermalResistance: Double

    /// Temperature decrease across the layer, K or °C.
    let temperatureDrop: Double

    /// Temperature at the hot boundary of the layer.
    let hotSideTemperature: Double

    /// Temperature at the cold boundary of the layer.
    let coldSideTemperature: Double
}

struct CompositeWallConductionResult:
    Equatable,
    Sendable {

    /// Total heat-transfer rate through the wall, W.
    let heatTransferRate: Double

    /// Heat-transfer rate per unit wall area, W/m².
    let heatFlux: Double

    /// Sum of all layer resistances, K/W.
    let totalThermalResistance: Double

    /// Overall wall temperature difference, K or °C.
    let temperatureDifference: Double

    /// Individual resistance and temperature data.
    let layerResults: [CompositeWallLayerResult]
}
