struct BinaryIsothermalFlashInput:
    Equatable,
    Sendable {

    let feedMolarFlow: Double
    let feedMoleFraction1:
        Double
    let equilibriumRatio1:
        Double
    let equilibriumRatio2:
        Double
}
