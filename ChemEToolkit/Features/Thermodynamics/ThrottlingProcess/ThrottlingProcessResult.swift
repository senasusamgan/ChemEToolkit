struct ThrottlingProcessResult: Equatable, Sendable {
    let pressureDrop: Double
    let temperatureChange: Double
    let outletTemperatureKelvin: Double
    let enthalpyChange: Double
    let trendDescription: String
    let modelName: String
    let limitationDescription: String
}
