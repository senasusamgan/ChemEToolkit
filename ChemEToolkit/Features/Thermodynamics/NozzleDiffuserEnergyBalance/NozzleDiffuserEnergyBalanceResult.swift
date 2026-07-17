struct NozzleDiffuserEnergyBalanceResult: Equatable, Sendable {
    let outletVelocity: Double
    let velocityChange: Double
    let specificKineticEnergyChange: Double
    let enthalpyChange: Double
    let deviceDescription: String
    let modelName: String
    let limitationDescription: String
}
