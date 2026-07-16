struct ImmobilizedEnzymeReactorResult: Equatable, Sendable {
    let firstOrderRateConstant: Double
    let thieleModulus: Double
    let effectivenessFactor: Double
    let intrinsicVolumetricRate: Double
    let observedVolumetricRate: Double
    let totalObservedMolarRate: Double
    let internalDiffusionLossFraction: Double
    let diffusionRegimeDescription: String
    let modelName: String
    let limitationDescription: String
}
