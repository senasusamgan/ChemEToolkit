struct MultipleReactionsCSTRResult:
    Equatable,
    Sendable {

    let requiredSpaceTime: Double
    let requiredReactorVolume: Double

    let outletConcentrationA: Double
    let outletConcentrationB: Double
    let outletConcentrationC: Double

    let yieldOfB: Double
    let selectivityBToC: Double
    let fractionOfReactedAEndingAsB:
        Double

    let theoreticalSpaceTimeForMaximumB:
        Double
    let theoreticalMaximumBConcentration:
        Double

    let modelName: String
    let limitationDescription: String
}
