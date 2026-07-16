struct InverseLaplaceTransformHelperResult:
    Equatable,
    Sendable {

    let transformExpression: String
    let timeDomainExpression: String
    let evaluatedTimeResponse: Double

    let initialValue: Double
    let finalValue: Double?

    let modelName: String
    let limitationDescription: String
}
