struct InterphaseEquilibriumDrivingForcesResult:
    Equatable,
    Sendable {

    let interfaceGasMoleFraction: Double
    let equilibriumGasMoleFractionForBulkLiquid: Double
    let equilibriumLiquidMoleFractionForBulkGas: Double
    let gasFilmDrivingForce: Double
    let liquidFilmDrivingForce: Double
    let overallGasDrivingForce: Double
    let overallLiquidDrivingForce: Double
    let directionDescription: String
    let consistencyDescription: String
    let modelName: String
}
