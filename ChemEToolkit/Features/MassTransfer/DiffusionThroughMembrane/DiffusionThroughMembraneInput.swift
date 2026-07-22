struct DiffusionThroughMembraneInput:
    Equatable,
    Sendable {

    let diffusivityInMembrane: Double
    let partitionCoefficient: Double
    let membraneThickness: Double
    let membraneArea: Double

    let sideOneConcentration: Double
    let sideTwoConcentration: Double
}
