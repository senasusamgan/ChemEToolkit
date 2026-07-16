struct SemibatchReactorInput:
    Equatable,
    Sendable {

    let initialLiquidVolume: Double
    let initialMolesB: Double

    let feedConcentrationA: Double
    let feedVolumetricFlowRate:
        Double

    let secondOrderRateConstant:
        Double
    let operationTime: Double
}
