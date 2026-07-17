struct ProofTestIntervalCalculatorInput:
    Equatable,
    Sendable {

    let dangerousFailureRate:
        Double
    let diagnosticCoverageFraction:
        Double
    let meanRepairTimeHours:
        Double
    let commonCausePFD:
        Double

    let targetAveragePFD:
        Double
}
