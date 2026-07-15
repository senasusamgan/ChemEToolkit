struct InterphaseEquilibriumDrivingForcesInput:
    Equatable,
    Sendable {

    let equilibriumSlope: Double
    let gasBulkMoleFraction: Double
    let liquidBulkMoleFraction: Double
    let interfaceLiquidMoleFraction: Double
}
