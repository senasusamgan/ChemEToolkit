struct PFRSectionsResult:
    Equatable,
    Sendable {

    let outletConcentrationSectionOne: Double
    let outletConcentrationSectionTwo: Double
    let outletConcentrationSectionThree: Double

    let sectionOneConversion: Double
    let sectionTwoIncrementalConversion: Double
    let sectionThreeIncrementalConversion: Double
    let overallConversion: Double

    let totalReactorVolume: Double
    let totalSpaceTime: Double
    let cumulativeFirstOrderExposure: Double
    let residenceTimeWeightedRateConstant: Double

    let modelName: String
    let limitationDescription: String
}
