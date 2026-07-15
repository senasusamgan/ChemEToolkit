struct OverallMassTransferCoefficientResult:
    Equatable,
    Sendable {

    let overallGasCoefficient: Double
    let overallLiquidCoefficient: Double
    let overallGasDrivingForce: Double
    let overallLiquidDrivingForce: Double
    let gasBasisMolarFlux: Double
    let liquidBasisMolarFlux: Double
    let molarRate: Double
    let gasResistanceFraction: Double
    let liquidResistanceFraction: Double
    let controllingResistance: String
    let directionDescription: String
    let modelName: String
}
