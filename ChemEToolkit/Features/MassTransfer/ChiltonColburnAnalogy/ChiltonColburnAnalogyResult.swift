struct ChiltonColburnAnalogyResult:
    Equatable,
    Sendable {

    let massTransferJFactor: Double
    let massTransferStantonNumber: Double
    let massTransferCoefficient: Double
    let sherwoodNumber: Double
    let modelName: String
    let frictionFactorConvention: String
}
