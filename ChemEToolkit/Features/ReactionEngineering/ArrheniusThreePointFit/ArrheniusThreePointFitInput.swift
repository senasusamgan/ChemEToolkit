struct ArrheniusThreePointFitInput:
    Equatable,
    Sendable {

    let temperatureOne: Double
    let rateConstantOne: Double

    let temperatureTwo: Double
    let rateConstantTwo: Double

    let temperatureThree: Double
    let rateConstantThree: Double
}
