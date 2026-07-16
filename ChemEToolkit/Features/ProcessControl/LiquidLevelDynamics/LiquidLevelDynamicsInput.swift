struct LiquidLevelDynamicsInput:
    Equatable,
    Sendable {

    let tankCrossSectionalArea:
        Double
    let hydraulicResistance: Double

    let initialLevel: Double
    let inletFlowStepChange: Double

    let evaluationTime: Double
    let maximumTankLevel: Double
}
