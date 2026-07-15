struct TwoFilmTheoryResult:
    Equatable,
    Sendable {

    let interfaceGasMoleFraction: Double
    let interfaceLiquidMoleFraction: Double
    let gasFilmDrivingForce: Double
    let liquidFilmDrivingForce: Double
    let molarFlux: Double
    let molarRate: Double
    let gasResistanceFraction: Double
    let liquidResistanceFraction: Double
    let controllingResistance: String
    let directionDescription: String
    let modelName: String
}
