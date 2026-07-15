struct CSTRsInSeriesInput:
    Equatable,
    Sendable {

    let firstOrderRateConstant: Double
    let totalReactorVolume: Double
    let volumetricFlowRate: Double
    let numberOfReactors: Double
}
