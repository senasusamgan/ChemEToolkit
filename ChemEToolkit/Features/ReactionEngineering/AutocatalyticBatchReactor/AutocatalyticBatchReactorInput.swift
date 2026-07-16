struct AutocatalyticBatchReactorInput:
    Equatable,
    Sendable {

    let initialConcentrationA: Double
    let initialConcentrationB: Double
    let rateConstant: Double
    let targetConversionA: Double
}
