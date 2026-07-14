struct FrictionFactorResult:
    Equatable,
    Sendable {

    let reynoldsNumber: Double
    let pipeDiameter: Double
    let absoluteRoughness: Double
    let relativeRoughness: Double

    let darcyFrictionFactor: Double
    let fanningFrictionFactor: Double

    let flowRegime: FlowRegime
    let iterationCount: Int

    var usedIterativeEquation: Bool {
        iterationCount > 0
    }
}
