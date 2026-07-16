struct LaplaceTransformHelperResult:
    Equatable,
    Sendable {

    let timeDomainExpression: String
    let transformExpression: String
    let evaluatedTransform: Double
    let convergenceDescription: String

    let modelName: String
    let limitationDescription: String
}
