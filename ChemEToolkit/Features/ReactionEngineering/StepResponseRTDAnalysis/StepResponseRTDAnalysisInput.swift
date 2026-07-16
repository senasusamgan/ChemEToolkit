struct StepResponseRTDAnalysisInput:
    Equatable,
    Sendable {

    let times: [Double]
    let normalizedOutletResponses:
        [Double]
}
