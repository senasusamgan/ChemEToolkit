struct PsychrometricAirEnthalpyInput:
    Equatable,
    Sendable {

    let dryBulbTemperatureC:
        Double
    let humidityRatio:
        Double
    let dryAirHeatCapacity:
        Double
    let vaporHeatCapacity:
        Double
    let referenceLatentHeat:
        Double
}
