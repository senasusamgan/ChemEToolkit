struct ConstantPressureFiltrationInput:
    Equatable,
    Sendable {

    let filtrateViscosity: Double
    let pressureDrop: Double
    let filterArea: Double

    let specificCakeResistance: Double
    let slurrySolidsPerFiltrateVolume:
        Double
    let filterMediumResistance: Double

    let targetFiltrateVolume: Double
}
