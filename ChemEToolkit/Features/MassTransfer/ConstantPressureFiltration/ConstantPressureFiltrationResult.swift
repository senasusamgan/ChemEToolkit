struct ConstantPressureFiltrationResult:
    Equatable,
    Sendable {

    let filtrationTime: Double
    let averageFiltrateFlowRate: Double

    let initialFiltrateFlowRate: Double
    let finalFiltrateFlowRate: Double

    let depositedCakeMass: Double
    let finalCakeResistance: Double
    let finalTotalResistance: Double

    let filtrationPlotSlope: Double
    let filtrationPlotIntercept: Double

    let cakeResistanceFraction:
        Double
    let mediumResistanceFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
