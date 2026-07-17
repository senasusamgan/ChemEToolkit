struct FilterCakeBalanceResult:
    Equatable,
    Sendable {

    let drySolidFlow: Double
    let feedLiquidFlow: Double

    let wetCakeMassFlow: Double
    let cakeLiquidFlow: Double
    let filtrateLiquidFlow: Double

    let cakeDrySolidMassFraction:
        Double
    let liquidRecoveryToFiltrate:
        Double

    let modelName: String
    let limitationDescription: String
}
