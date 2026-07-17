struct BinaryCompositionBasisConversionResult:
    Equatable,
    Sendable {

    let component1MassFraction:
        Double
    let component2MassFraction:
        Double

    let component1MoleFraction:
        Double
    let component2MoleFraction:
        Double

    let mixtureMolecularWeight:
        Double
    let recoveredMassFraction1:
        Double

    let modelName: String
    let limitationDescription: String
}
