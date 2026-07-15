struct MembraneGasSeparationResult:
    Equatable,
    Sendable {

    let idealSelectivity: Double
    let pressureRatio: Double

    let permeateFastComponentMoleFraction: Double
    let retentateFastComponentMoleFraction: Double

    let fastComponentFlux: Double
    let slowComponentFlux: Double
    let totalMolarFlux: Double

    let permeateMolarFlowRate: Double
    let retentateMolarFlowRate: Double
    let stageCut: Double

    let fastComponentRecovery: Double
    let purityIncrease: Double

    let validityDescription: String
    let modelName: String
}
