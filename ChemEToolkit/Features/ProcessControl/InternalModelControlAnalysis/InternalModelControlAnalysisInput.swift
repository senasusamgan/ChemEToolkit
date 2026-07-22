struct InternalModelControlAnalysisInput:
    Equatable,
    Sendable {

    let actualProcessGain: Double
    let actualTimeConstant: Double

    let modelProcessGain: Double
    let modelTimeConstant: Double
    let modelDeadTime: Double

    let filterTimeConstant: Double
    let angularFrequency: Double
}
