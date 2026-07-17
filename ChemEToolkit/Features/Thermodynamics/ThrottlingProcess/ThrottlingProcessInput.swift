struct ThrottlingProcessInput: Equatable, Sendable {
    let inletTemperatureKelvin: Double
    let inletAbsolutePressure: Double
    let outletAbsolutePressure: Double
    let jouleThomsonCoefficient: Double
}
