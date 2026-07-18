struct ConstantPressureFilterSizingResult: Equatable, Sendable {
    let mediumTimeContribution: Double
    let cakeTimeContribution: Double
    let totalFiltrationTime: Double
    let averageFiltrateRate: Double
    let finalCakeMass: Double
    let modelName: String
    let limitationDescription: String
}
