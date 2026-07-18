struct ConstantPressureFilterSizingInput: Equatable, Sendable {
    let filtrateVolume: Double
    let filterArea: Double
    let pressureDrop: Double
    let liquidViscosity: Double
    let mediumResistance: Double
    let specificCakeResistance: Double
    let solidsPerFiltrateVolume: Double
}
