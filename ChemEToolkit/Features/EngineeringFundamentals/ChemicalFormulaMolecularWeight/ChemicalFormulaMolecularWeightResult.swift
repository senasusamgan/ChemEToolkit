struct ChemicalFormulaMolecularWeightResult:
    Equatable,
    Sendable {

    let normalizedFormula: String
    let molecularWeight: Double
    let totalAtomCount: Int
    let distinctElementCount: Int
    let elementalBreakdown: String

    let modelName: String
    let limitationDescription: String
}
