struct HumidifierWaterBalanceInput:
    Equatable,
    Sendable {

    let dryGasMassFlow: Double
    let inletHumidityRatio:
        Double
    let outletHumidityRatio:
        Double
}
