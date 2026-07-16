struct NonInteractingTankSystemInput:
    Equatable,
    Sendable {

    let firstTankArea: Double
    let firstTankResistance: Double

    let secondTankArea: Double
    let secondTankResistance: Double

    let inletFlowStepChange: Double
    let evaluationTime: Double
}
