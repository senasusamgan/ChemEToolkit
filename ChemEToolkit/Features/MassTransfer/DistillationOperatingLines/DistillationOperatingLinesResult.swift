struct DistillationOperatingLinesResult: Equatable, Sendable {
    let rectifyingSlope: Double
    let rectifyingIntercept: Double
    let feedLineSlope: Double?
    let feedLineDescription: String
    let feedIntersectionLiquidMoleFraction: Double
    let feedIntersectionVaporMoleFraction: Double
    let strippingSlope: Double
    let strippingIntercept: Double
    let minimumRefluxRatio: Double
    let actualToMinimumRefluxRatio: Double
    let minimumRefluxPinchLiquidMoleFraction: Double
    let minimumRefluxPinchVaporMoleFraction: Double
    let modelName: String
}
