struct IdealGasMixturePropertiesResult:
    Equatable,
    Sendable {

    let enteredFractionSum: Double
    let normalizedFraction1: Double
    let normalizedFraction2: Double
    let normalizedFraction3: Double

    let mixtureMolecularWeight:
        Double
    let mixtureSpecificGasConstant:
        Double
    let reciprocalMolecularWeight:
        Double

    let modelName: String
    let limitationDescription: String
}
