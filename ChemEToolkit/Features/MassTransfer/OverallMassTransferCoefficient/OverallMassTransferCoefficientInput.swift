struct OverallMassTransferCoefficientInput:
    Equatable,
    Sendable {

    let gasFilmCoefficient: Double
    let liquidFilmCoefficient: Double
    let equilibriumSlope: Double
    let gasBulkMoleFraction: Double
    let liquidBulkMoleFraction: Double
    let interfacialArea: Double
}
