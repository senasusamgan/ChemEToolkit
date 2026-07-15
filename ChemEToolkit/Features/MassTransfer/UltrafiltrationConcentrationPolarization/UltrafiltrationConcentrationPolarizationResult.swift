struct UltrafiltrationConcentrationPolarizationResult:
    Equatable,
    Sendable {

    let limitingFluxMetersPerHour: Double
    let limitingFluxLMH: Double
    let polarizationModulus: Double

    let permeateFlowRate: Double
    let retentateFlowRate: Double
    let volumetricRecoveryFraction: Double

    let permeateSoluteConcentration: Double
    let retentateSoluteConcentration: Double
    let observedRejection: Double
    let concentrationFactor: Double

    let retainedSoluteRate: Double
    let soluteBalanceResidual: Double

    let modelName: String
    let limitationDescription: String
}
