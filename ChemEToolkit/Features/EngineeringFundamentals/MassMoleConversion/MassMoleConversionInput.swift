struct MassMoleConversionInput:
    Equatable,
    Sendable {

    let massKilograms: Double
    let molecularWeightKilogramsPerKilomole:
        Double
}
