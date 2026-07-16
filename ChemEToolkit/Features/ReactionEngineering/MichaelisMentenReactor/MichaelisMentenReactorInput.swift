struct MichaelisMentenReactorInput: Equatable, Sendable {
    let inletSubstrateConcentration: Double
    let volumetricFlowRate: Double
    let maximumVolumetricRate: Double
    let michaelisConstant: Double
    let targetSubstrateConversion: Double
}
