struct FiniteVolumeDialysisResult:
    Equatable,
    Sendable {

    let equilibriumConcentration: Double
    let concentrationDifferenceDecayFactor:
        Double
    let fractionOfEquilibriumApproach:
        Double

    let donorFinalConcentration: Double
    let receiverFinalConcentration:
        Double

    let signedTransferredAmountToReceiver:
        Double
    let transferMagnitude: Double

    let initialSignedFlux: Double
    let finalSignedFlux: Double

    let systemRateConstant: Double
    let concentrationDifferenceHalfTime:
        Double

    let totalAmountBalanceResidual:
        Double
    let directionDescription: String
    let modelName: String
}
