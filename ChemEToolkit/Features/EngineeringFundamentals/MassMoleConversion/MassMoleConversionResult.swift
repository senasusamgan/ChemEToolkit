struct MassMoleConversionResult:
    Equatable,
    Sendable {

    let amountKilomoles: Double
    let amountMoles: Double
    let amountMillimoles: Double
    let backCalculatedMassKilograms:
        Double

    let modelName: String
    let limitationDescription: String
}
