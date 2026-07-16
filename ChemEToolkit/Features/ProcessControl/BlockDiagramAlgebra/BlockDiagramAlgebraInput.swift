struct BlockDiagramAlgebraInput:
    Equatable,
    Sendable {

    let firstForwardBlockGain:
        Double
    let secondForwardBlockGain:
        Double
    let feedbackBlockGain: Double
}
