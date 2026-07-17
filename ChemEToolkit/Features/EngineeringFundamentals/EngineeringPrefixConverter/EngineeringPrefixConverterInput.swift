struct EngineeringPrefixConverterInput:
    Equatable,
    Sendable {

    let enteredValue: Double
    let inputPowerOfTen: Double
    let outputPowerOfTen: Double
}
