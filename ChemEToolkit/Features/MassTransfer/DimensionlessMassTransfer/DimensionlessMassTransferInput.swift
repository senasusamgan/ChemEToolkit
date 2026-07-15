struct DimensionlessMassTransferInput: Equatable, Sendable {
    let density: Double
    let dynamicViscosity: Double
    let diffusivity: Double
    let thermalDiffusivity: Double
    let massTransferCoefficient: Double
    let characteristicLength: Double
}
