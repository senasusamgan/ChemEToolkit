struct MixtureDensityCalculatorInput:
    Equatable,
    Sendable {

    let mass1: Double
    let density1: Double

    let mass2: Double
    let density2: Double

    let mass3: Double
    let density3: Double
}
