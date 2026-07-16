struct ReactorOptimizationInput:
    Equatable,
    Sendable {

    let inletConcentrationA: Double
    let volumetricFlowRate: Double

    let firstRateConstant: Double
    let secondRateConstant: Double
}
