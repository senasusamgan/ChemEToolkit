struct MichaelisMentenReactorResult: Equatable, Sendable {
    let outletSubstrateConcentration: Double
    let productConcentration: Double
    let pfrSpaceTime: Double
    let pfrVolume: Double
    let cstrSpaceTime: Double
    let cstrVolume: Double
    let cstrToPFRVolumeRatio: Double
    let inletReactionRate: Double
    let outletReactionRate: Double
    let modelName: String
    let limitationDescription: String
}
