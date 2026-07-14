struct MinorLossResult:
    Equatable,
    Sendable {

    let lossCoefficients: [Double]
    let totalLossCoefficient: Double

    let velocityHead: Double
    let headLoss: Double
    let pressureDrop: Double

    var pressureDropKilopascals: Double {
        pressureDrop / 1_000
    }

    var fittingCount: Int {
        lossCoefficients.count
    }
}
