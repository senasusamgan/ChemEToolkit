struct DiffusionThroughMembraneResult:
    Equatable,
    Sendable {

    let membranePermeability: Double
    let membranePermeance: Double
    let membraneResistance: Double

    let sideOneMembraneConcentration: Double
    let sideTwoMembraneConcentration: Double
    let membraneConcentrationDifference: Double

    let signedMolarFlux: Double
    let transferRateMagnitude: Double

    let directionDescription: String
    let modelName: String
    let limitationDescription: String
}
