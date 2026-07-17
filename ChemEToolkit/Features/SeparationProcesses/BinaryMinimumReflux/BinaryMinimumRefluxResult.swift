struct BinaryMinimumRefluxResult:
    Equatable,
    Sendable {

    let equilibriumVaporAtFeed:
        Double
    let rectifyingLineMinimumSlope:
        Double
    let minimumRefluxRatio:
        Double
    let feedEquilibriumEnrichment:
        Double
    let pinchDescription: String

    let modelName: String
    let limitationDescription: String
}
