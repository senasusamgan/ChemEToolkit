import Foundation
struct TanksInSeriesRTDEngine: Sendable {
    func calculate(_ input: TanksInSeriesRTDInput) throws -> TanksInSeriesRTDResult {
        guard [input.meanResidenceTime, input.numberOfTanks, input.evaluationTime].allSatisfy(\.isFinite) else { throw TanksInSeriesRTDError.nonFiniteInput }
        guard input.meanResidenceTime > 0 else { throw TanksInSeriesRTDError.nonPositiveMeanResidenceTime }
        let rounded = input.numberOfTanks.rounded()
        guard abs(rounded - input.numberOfTanks) < 1e-10, rounded >= 1, rounded <= 100 else { throw TanksInSeriesRTDError.invalidTankCount }
        guard input.evaluationTime >= 0 else { throw TanksInSeriesRTDError.negativeEvaluationTime }

        let count = Int(rounded)
        let theta = input.evaluationTime / input.meanResidenceTime
        let dimensionlessE: Double
        if theta == 0 {
            dimensionlessE = count == 1 ? 1 : 0
        } else {
            dimensionlessE = exp(
                Double(count) * log(Double(count))
                + Double(count - 1) * log(theta)
                - Double(count) * theta
                - lgamma(Double(count))
            )
        }
        let variance = input.meanResidenceTime * input.meanResidenceTime / Double(count)
        let eValue = dimensionlessE / input.meanResidenceTime
        let peakTime = count == 1 ? 0 : Double(count - 1) / Double(count) * input.meanResidenceTime

        guard [theta, eValue, variance, peakTime].allSatisfy(\.isFinite) else {
            throw TanksInSeriesRTDError.numericalFailure
        }

        return .init(
            numberOfTanks: count,
            dimensionlessTime: theta,
            eValue: eValue,
            dimensionlessVariance: 1 / Double(count),
            variance: variance,
            standardDeviation: variance.squareRoot(),
            peakTime: peakTime,
            modelName: "Ideal equal-volume tanks-in-series RTD model",
            limitationDescription: "Assumes identical ideal CSTRs without bypassing, dead volume or stagnant-zone exchange."
        )
    }
}
