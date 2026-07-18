struct UltrafiltrationResistanceSeriesResult:
    Equatable,
    Sendable {

    let totalResistance: Double
    let cleanMembraneFlux: Double
    let fouledMembraneFlux: Double
    let fluxDeclineFraction: Double
    let requiredMembraneArea: Double

    let modelName: String
    let limitationDescription: String
}
