struct TNTEquivalentExplosionScreeningResult:
    Equatable,
    Sendable {

    let availableCombustionEnergy:
        Double
    let explosionEnergy: Double
    let tntEquivalentMass: Double

    let cubeRootScaledDistance:
        Double
    let inverseScaledDistance:
        Double

    let proximityBand: String
    let screeningDescription:
        String

    let modelName: String
    let limitationDescription: String
}
