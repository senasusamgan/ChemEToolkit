struct EnzymeBatchReactorInput: Equatable, Sendable {
    let liquidVolume: Double
    let initialSubstrateConcentration: Double
    let maximumVolumetricRate: Double
    let michaelisConstant: Double
    let targetSubstrateConversion: Double
}
