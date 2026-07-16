struct SemibatchReactorResult:
    Equatable,
    Sendable {

    let finalLiquidVolume: Double

    let totalMolesAFed: Double
    let finalMolesA: Double
    let finalMolesB: Double
    let productMoles: Double

    let finalConcentrationA: Double
    let finalConcentrationB: Double
    let finalProductConcentration:
        Double

    let conversionOfFedA: Double
    let conversionOfInitialB: Double

    let maximumReactionRate:
        Double
    let timeAtMaximumReactionRate:
        Double

    let modelName: String
    let limitationDescription: String
}
