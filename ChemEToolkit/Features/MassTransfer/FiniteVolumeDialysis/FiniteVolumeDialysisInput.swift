struct FiniteVolumeDialysisInput:
    Equatable,
    Sendable {

    let donorVolume: Double
    let receiverVolume: Double
    let membraneArea: Double
    let overallMassTransferCoefficient:
        Double
    let contactTime: Double

    let donorInitialConcentration:
        Double
    let receiverInitialConcentration:
        Double
}
