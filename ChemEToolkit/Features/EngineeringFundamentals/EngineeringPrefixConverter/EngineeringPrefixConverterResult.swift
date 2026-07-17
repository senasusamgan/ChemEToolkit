struct EngineeringPrefixConverterResult:
    Equatable,
    Sendable {

    let convertedValue: Double
    let conversionFactor: Double
    let inputPowerOfTen: Int
    let outputPowerOfTen: Int
    let inputPrefixName: String
    let outputPrefixName: String

    let modelName: String
    let limitationDescription: String
}
