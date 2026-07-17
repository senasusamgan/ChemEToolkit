struct NozzleDiffuserEnergyBalanceInput: Equatable, Sendable {
    let inletEnthalpy: Double
    let outletEnthalpy: Double
    let inletVelocity: Double
    let heatTransferPerUnitMass: Double
    let workByControlVolumePerUnitMass: Double
}
