struct BinaryFlashCalculationInput: Equatable, Sendable {
    let feedFlowRate: Double
    let feedLightMoleFraction: Double
    let lightComponentKValue: Double
    let heavyComponentKValue: Double
}
