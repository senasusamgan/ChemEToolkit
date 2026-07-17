struct MembraneSeparatorBalanceResult:
    Equatable,
    Sendable {

    let permeateMassFlow: Double
    let retentateMassFlow: Double

    let permeateComponentMassFraction:
        Double
    let retentateComponentMassFraction:
        Double

    let feedComponentFlow: Double
    let permeateComponentFlow:
        Double
    let retentateComponentFlow:
        Double

    let componentRecoveryToRetentate:
        Double

    let modelName: String
    let limitationDescription: String
}
