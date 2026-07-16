struct MonodBioreactorDesignResult: Equatable, Sendable {
    let specificGrowthRate: Double
    let dilutionRate: Double
    let hydraulicResidenceTime: Double
    let requiredReactorVolume: Double
    let biomassConcentration: Double
    let substrateConversionFraction: Double
    let washoutDilutionRate: Double
    let minimumWashoutResidenceTime: Double
    let washoutSafetyRatio: Double
    let modelName: String
    let limitationDescription: String
}
