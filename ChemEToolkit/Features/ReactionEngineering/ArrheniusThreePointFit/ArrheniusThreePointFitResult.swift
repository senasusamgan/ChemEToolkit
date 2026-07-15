struct ArrheniusThreePointFitResult:
    Equatable,
    Sendable {

    let activationEnergy: Double
    let activationEnergyKilojoulesPerMole:
        Double
    let preExponentialFactor: Double

    let slope: Double
    let intercept: Double
    let coefficientOfDetermination:
        Double

    let predictedRateConstantOne: Double
    let predictedRateConstantTwo: Double
    let predictedRateConstantThree: Double

    let maximumRelativeResidual: Double

    let fitQualityDescription: String
    let modelName: String
}
