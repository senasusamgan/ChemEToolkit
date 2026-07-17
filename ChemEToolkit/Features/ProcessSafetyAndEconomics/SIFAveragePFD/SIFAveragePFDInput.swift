struct SIFAveragePFDInput:
    Equatable,
    Sendable {

    let dangerousFailureRate:
        Double
    let diagnosticCoverageFraction:
        Double
    let proofTestIntervalHours:
        Double
    let meanRepairTimeHours:
        Double
    let commonCausePFD:
        Double
}
