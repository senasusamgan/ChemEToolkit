struct ConvectiveMassTransferCorrelationsResult:
    Equatable,
    Sendable {

    let sherwoodNumber: Double
    let massTransferCoefficient: Double
    let correlationName: String
    let validityDescription: String
}
