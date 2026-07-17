struct ToxicExposureDoseScreeningInput:
    Equatable,
    Sendable {

    let exposureConcentration:
        Double
    let exposureDuration: Double
    let concentrationExponent:
        Double
    let referenceDose: Double
}
