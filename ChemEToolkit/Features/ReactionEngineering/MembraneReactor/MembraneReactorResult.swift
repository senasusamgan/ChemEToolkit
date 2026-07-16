struct MembraneReactorResult:
    Equatable,
    Sendable {

    let outletConcentrationA: Double
    let outletConcentrationB: Double
    let removedProductEquivalent:
        Double

    let conversionOfA: Double
    let productRemovalFraction:
        Double

    let conversionWithoutMembrane:
        Double
    let membraneConversionGain:
        Double

    let massBalanceClosure:
        Double

    let modelName: String
    let limitationDescription: String
}
