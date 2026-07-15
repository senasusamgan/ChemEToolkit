struct McCabeThieleMethodInput: Equatable, Sendable {
    let relativeVolatility: Double
    let distillateLightMoleFraction: Double
    let bottomsLightMoleFraction: Double
    let feedLightMoleFraction: Double
    let refluxRatio: Double
    let feedQuality: Double
}
