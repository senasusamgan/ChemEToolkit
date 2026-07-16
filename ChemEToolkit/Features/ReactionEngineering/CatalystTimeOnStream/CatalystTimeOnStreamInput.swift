struct CatalystTimeOnStreamInput:
    Equatable,
    Sendable {

    let freshDamkohlerNumber:
        Double
    let deactivationRateConstant:
        Double

    let minimumAcceptableConversion:
        Double
}
