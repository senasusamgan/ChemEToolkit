struct EffectiveDiffusivityResult:
    Equatable,
    Sendable {

    let porousMediumCorrectionFactor:
        Double

    let effectiveMolecularDiffusivity:
        Double
    let bosanquetPoreDiffusivity:
        Double
    let effectiveCombinedDiffusivity:
        Double

    let molecularResistanceFraction:
        Double
    let knudsenResistanceFraction:
        Double

    let reductionRelativeToMolecularDiffusivity:
        Double

    let modelName: String
    let limitationDescription: String
}
