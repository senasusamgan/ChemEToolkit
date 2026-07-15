struct ConversionYieldSelectivityInput:
    Equatable,
    Sendable {

    let initialReactantMoles: Double
    let finalReactantMoles: Double

    let desiredProductMoles: Double
    let undesiredProductMoles: Double

    let desiredProductStoichiometricYield:
        Double
    let undesiredProductStoichiometricYield:
        Double
}
