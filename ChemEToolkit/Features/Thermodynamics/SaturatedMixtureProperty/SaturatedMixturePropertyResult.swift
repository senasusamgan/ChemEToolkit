struct SaturatedMixturePropertyResult:
    Equatable,
    Sendable {

    let propertyDifference: Double
    let mixtureProperty: Double
    let liquidContribution:
        Double
    let vaporContribution:
        Double
    let liquidMassFraction:
        Double
    let vaporMassFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
