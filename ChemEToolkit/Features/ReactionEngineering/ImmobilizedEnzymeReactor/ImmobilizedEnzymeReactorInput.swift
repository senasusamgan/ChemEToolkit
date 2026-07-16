struct ImmobilizedEnzymeReactorInput: Equatable, Sendable {
    let sphericalPelletRadius: Double
    let effectiveDiffusivity: Double
    let maximumVolumetricRate: Double
    let michaelisConstant: Double
    let bulkSubstrateConcentration: Double
    let totalPelletVolume: Double
}
