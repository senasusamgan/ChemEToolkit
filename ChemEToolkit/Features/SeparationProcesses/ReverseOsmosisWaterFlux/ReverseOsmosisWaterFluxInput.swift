struct ReverseOsmosisWaterFluxInput:
    Equatable,
    Sendable {

    let hydraulicPressureDifference: Double
    let osmoticPressureDifference: Double
    let waterPermeability: Double
    let targetPermeateFlow: Double
    let recoveryFraction: Double
}
