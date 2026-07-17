struct DaltonPartialPressureInput:
    Equatable,
    Sendable {

    let totalAbsolutePressure: Double
    let amountFraction1: Double
    let amountFraction2: Double
    let amountFraction3: Double
}
