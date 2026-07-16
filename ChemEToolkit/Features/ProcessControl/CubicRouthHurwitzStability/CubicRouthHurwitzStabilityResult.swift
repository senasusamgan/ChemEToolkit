struct CubicRouthHurwitzStabilityResult: Equatable, Sendable {
    let firstColumnOne: Double
    let firstColumnTwo: Double
    let firstColumnThree: Double
    let firstColumnFour: Double
    let signChangeCount: Int
    let isAsymptoticallyStable: Bool
    let stabilityMargin: Double
    let classificationDescription: String
    let modelName: String
    let limitationDescription: String
}
