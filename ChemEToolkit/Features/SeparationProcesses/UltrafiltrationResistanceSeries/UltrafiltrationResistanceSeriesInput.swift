struct UltrafiltrationResistanceSeriesInput:
    Equatable,
    Sendable {

    let transmembranePressure: Double
    let fluidViscosity: Double
    let membraneResistance: Double
    let foulingResistance: Double
    let targetPermeateFlow: Double
}
