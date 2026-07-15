struct UltrafiltrationConcentrationPolarizationInput:
    Equatable,
    Sendable {

    let feedVolumetricFlowRate: Double
    let membraneArea: Double

    let liquidSideMassTransferCoefficient: Double
    let bulkSoluteConcentration: Double
    let gelConcentration: Double

    let observedSievingCoefficient: Double
}
