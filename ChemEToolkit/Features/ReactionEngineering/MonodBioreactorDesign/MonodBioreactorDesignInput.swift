struct MonodBioreactorDesignInput: Equatable, Sendable {
    let feedSubstrateConcentration: Double
    let targetEffluentSubstrate: Double
    let maximumSpecificGrowthRate: Double
    let monodHalfSaturationConstant: Double
    let biomassYieldCoefficient: Double
    let biomassDecayRate: Double
    let volumetricFlowRate: Double
}
