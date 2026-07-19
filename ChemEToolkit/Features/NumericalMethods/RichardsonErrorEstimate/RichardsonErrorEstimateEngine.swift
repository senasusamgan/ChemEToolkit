import Foundation

struct RichardsonErrorEstimateEngine: Sendable {
    func calculate(_ input: RichardsonErrorEstimateInput) throws -> RichardsonErrorEstimateResult {
        let values = [input.coarseResult,input.fineResult,input.refinementRatio,input.methodOrder]
        guard values.allSatisfy(\.isFinite) else { throw RichardsonErrorEstimateError.nonFiniteInput }
        guard input.refinementRatio > 1 else { throw RichardsonErrorEstimateError.invalidRefinementRatio }
        guard input.methodOrder > 0 else { throw RichardsonErrorEstimateError.invalidMethodOrder }

        let power = Foundation.pow(input.refinementRatio,input.methodOrder)
        let denominator = power-1
        guard abs(denominator) > 1e-14 else { throw RichardsonErrorEstimateError.singularExtrapolation }
        let correction = (input.fineResult-input.coarseResult)/denominator
        let extrapolated = input.fineResult+correction
        let error = extrapolated-input.fineResult
        let relative = abs(error/extrapolated)*100
        let direction = error >= 0 ? 1.0 : -1.0
        guard [correction,extrapolated,error,relative,direction].allSatisfy(\.isFinite) else {
            throw RichardsonErrorEstimateError.numericalFailure
        }
        return .init(
            extrapolatedResult: extrapolated,
            estimatedFineGridError: error,
            estimatedRelativeErrorPercent: relative,
            correctionFactor: correction,
            convergenceDirection: direction,
            modelName: "Two-grid Richardson extrapolation",
            limitationDescription: "Assumes asymptotic convergence with known method order."
        )
    }
}
