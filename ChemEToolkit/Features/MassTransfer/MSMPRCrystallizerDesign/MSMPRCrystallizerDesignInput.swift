struct MSMPRCrystallizerDesignInput:
    Equatable,
    Sendable {

    let residenceTime: Double
    let linearCrystalGrowthRate: Double
    let nucleiPopulationDensity:
        Double

    let crystalDensity: Double
    let crystalVolumeShapeFactor:
        Double
    let slurryVolumetricFlowRate:
        Double

    let evaluationCrystalSize:
        Double
}
