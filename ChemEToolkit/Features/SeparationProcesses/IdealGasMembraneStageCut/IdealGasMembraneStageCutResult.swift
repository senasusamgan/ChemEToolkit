struct IdealGasMembraneStageCutResult:
    Equatable,
    Sendable {

    let permeateMolarFlow: Double
    let retentateMolarFlow: Double
    let permeateFastComponentFraction: Double
    let retentateFastComponentFraction: Double
    let fastComponentRecovery: Double
    let enrichmentFactor: Double

    let modelName: String
    let limitationDescription: String
}
