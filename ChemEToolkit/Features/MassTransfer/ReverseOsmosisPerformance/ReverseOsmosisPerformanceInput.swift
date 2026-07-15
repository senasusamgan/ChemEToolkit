struct ReverseOsmosisPerformanceInput:
    Equatable,
    Sendable {

    let feedVolumetricFlowRate: Double
    let membraneArea: Double

    let waterPermeabilityLMHPerBar: Double
    let appliedPressureDifferenceBar: Double
    let osmoticPressureDifferenceBar: Double

    let solutePermeabilityMetersPerHour: Double
    let feedSoluteConcentration: Double
}
