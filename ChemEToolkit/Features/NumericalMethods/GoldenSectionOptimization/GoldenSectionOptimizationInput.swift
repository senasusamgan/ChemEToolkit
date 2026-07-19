struct GoldenSectionOptimizationInput: Equatable, Sendable {
    let quadraticA: Double
    let quadraticB: Double
    let quadraticC: Double
    let lowerBound: Double
    let upperBound: Double
    let tolerance: Double
    let maximumIterations: Double
}
