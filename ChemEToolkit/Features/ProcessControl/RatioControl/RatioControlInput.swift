struct RatioControlInput:
    Equatable,
    Sendable {

    let wildStreamFlow: Double
    let desiredFlowRatio: Double
    let trimBias: Double

    let minimumControlledFlow:
        Double
    let maximumControlledFlow:
        Double

    let measuredControlledFlow:
        Double
}
