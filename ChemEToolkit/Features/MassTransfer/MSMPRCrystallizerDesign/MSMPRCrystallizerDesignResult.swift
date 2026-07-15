struct MSMPRCrystallizerDesignResult:
    Equatable,
    Sendable {

    let characteristicCrystalSize:
        Double

    let numberMeanCrystalSize:
        Double
    let surfaceWeightedMeanSize:
        Double
    let volumeWeightedMeanSize:
        Double

    let totalCrystalNumberConcentration:
        Double
    let thirdPopulationMoment:
        Double

    let solidsVolumeFraction: Double
    let crystalMassConcentration:
        Double
    let crystalProductionRate:
        Double

    let evaluationCrystalSize:
        Double
    let populationDensityAtEvaluationSize:
        Double
    let fractionByNumberAboveEvaluationSize:
        Double

    let modelName: String
    let limitationDescription: String
}
