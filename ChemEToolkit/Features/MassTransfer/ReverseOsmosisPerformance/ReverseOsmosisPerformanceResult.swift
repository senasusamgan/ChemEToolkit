struct ReverseOsmosisPerformanceResult:
    Equatable,
    Sendable {

    let netDrivingPressureBar: Double
    let waterFluxMetersPerHour: Double
    let waterFluxLMH: Double

    let permeateFlowRate: Double
    let concentrateFlowRate: Double
    let waterRecoveryFraction: Double

    let permeateSoluteConcentration: Double
    let concentrateSoluteConcentration: Double
    let observedSoluteRejection: Double

    let permeateSoluteRecoveryFraction: Double
    let concentrationFactor: Double
    let soluteBalanceResidual: Double

    let modelName: String
    let limitationDescription: String
}
