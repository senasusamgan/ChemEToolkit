struct PsychrometricAirEnthalpyResult:
    Equatable,
    Sendable {

    let humidAirEnthalpy:
        Double
    let dryAirSensibleContribution:
        Double
    let vaporLatentContribution:
        Double
    let vaporSensibleContribution:
        Double
    let humidHeat:
        Double

    let modelName: String
    let limitationDescription:
        String
}
