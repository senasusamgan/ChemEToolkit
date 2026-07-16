struct InteractingTankSystemInput:
    Equatable,
    Sendable {

    let firstTankArea: Double
    let secondTankArea: Double

    let interTankResistance: Double
    let outletResistance: Double

    let inletFlowStepChange: Double
    let evaluationTime: Double
}
