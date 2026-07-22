import Foundation
struct AxialDispersionRTDEngine: Sendable {
    func calculate(_ input: AxialDispersionRTDInput) throws -> AxialDispersionRTDResult {
        guard [input.meanResidenceTime, input.pecletNumber, input.evaluationTime].allSatisfy(\.isFinite) else { throw AxialDispersionRTDError.nonFiniteInput }
        guard input.meanResidenceTime > 0 else { throw AxialDispersionRTDError.nonPositiveMeanResidenceTime }
        guard input.pecletNumber >= 0.1, input.pecletNumber <= 10_000 else { throw AxialDispersionRTDError.pecletOutOfRange }
        guard input.evaluationTime > 0 else { throw AxialDispersionRTDError.nonPositiveEvaluationTime }

        let theta = input.evaluationTime / input.meanResidenceTime
        let dimE = (input.pecletNumber / (4 * Double.pi * theta)).squareRoot()
            * exp(-input.pecletNumber * (1 - theta) * (1 - theta) / (4 * theta))
        let dimVariance = 2 / input.pecletNumber
        let variance = dimVariance * input.meanResidenceTime * input.meanResidenceTime

        guard [theta, dimE, dimVariance, variance].allSatisfy(\.isFinite) else {
            throw AxialDispersionRTDError.numericalFailure
        }

        return .init(
            dimensionlessTime: theta,
            eValue: dimE / input.meanResidenceTime,
            dimensionlessEValue: dimE,
            dimensionlessVariance: dimVariance,
            variance: variance,
            standardDeviation: variance.squareRoot(),
            dispersionNumber: 1 / input.pecletNumber,
            equivalentTanksInSeries: input.pecletNumber / 2,
            modelName: "Open-boundary axial-dispersion RTD approximation",
            limitationDescription: "Uses the common axial-dispersion approximation with dimensionless variance 2/Pe."
        )
    }
}
