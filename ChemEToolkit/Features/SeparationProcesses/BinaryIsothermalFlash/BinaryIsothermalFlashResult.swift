struct BinaryIsothermalFlashResult:
    Equatable,
    Sendable {

    let vaporFraction: Double
    let liquidFraction: Double
    let vaporMolarFlow: Double
    let liquidMolarFlow: Double

    let liquidMoleFraction1:
        Double
    let liquidMoleFraction2:
        Double
    let vaporMoleFraction1:
        Double
    let vaporMoleFraction2:
        Double

    let phaseDescription: String

    let modelName: String
    let limitationDescription: String
}
