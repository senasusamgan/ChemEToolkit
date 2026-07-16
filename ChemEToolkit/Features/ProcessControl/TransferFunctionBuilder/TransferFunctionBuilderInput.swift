struct TransferFunctionBuilderInput:
    Equatable,
    Sendable {

    let numeratorLinearCoefficient:
        Double
    let numeratorConstant:
        Double

    let denominatorQuadraticCoefficient:
        Double
    let denominatorLinearCoefficient:
        Double
    let denominatorConstant:
        Double

    let angularFrequency: Double
}
