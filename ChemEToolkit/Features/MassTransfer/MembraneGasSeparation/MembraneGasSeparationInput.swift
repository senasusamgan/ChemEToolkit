struct MembraneGasSeparationInput:
    Equatable,
    Sendable {

    let feedMolarFlowRate: Double
    let membraneArea: Double

    let feedPressureBar: Double
    let permeatePressureBar: Double
    let feedFastComponentMoleFraction: Double

    let fastComponentPermeanceGPU: Double
    let slowComponentPermeanceGPU: Double
}
