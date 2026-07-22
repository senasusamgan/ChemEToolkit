struct MixtureDensityCalculatorResult:
    Equatable,
    Sendable {

    let totalMass: Double
    let totalAdditiveVolume: Double
    let mixtureDensity: Double

    let massFraction1: Double
    let massFraction2: Double
    let massFraction3: Double

    let modelName: String
    let limitationDescription: String
}
