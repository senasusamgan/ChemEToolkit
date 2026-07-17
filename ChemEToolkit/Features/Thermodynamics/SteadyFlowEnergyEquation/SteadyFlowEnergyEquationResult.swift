struct SteadyFlowEnergyEquationResult: Equatable, Sendable {
    let specificEnthalpyChange: Double
    let specificKineticEnergyChange: Double
    let specificPotentialEnergyChange: Double
    let totalSpecificEnergyChange: Double
    let requiredHeatTransferRate: Double
    let directionDescription: String
    let modelName: String
    let limitationDescription: String
}
