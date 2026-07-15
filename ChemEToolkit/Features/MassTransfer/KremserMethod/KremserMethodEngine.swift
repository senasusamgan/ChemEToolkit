import Foundation

struct KremserMethodEngine: Sendable {
    private let unityTolerance = 1.0e-10

    func calculate(_ input: KremserMethodInput) throws -> KremserMethodResult {
        let values = [
            input.operatingFactor,
            input.inletSoluteRatio,
            input.targetOutletSoluteRatio
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw KremserMethodError.nonFiniteInput
        }
        guard input.operatingFactor > 0 else {
            throw KremserMethodError.nonPositiveOperatingFactor
        }
        guard input.inletSoluteRatio > 0 else {
            throw KremserMethodError.nonPositiveInletRatio
        }
        guard input.targetOutletSoluteRatio > 0,
              input.targetOutletSoluteRatio < input.inletSoluteRatio else {
            throw KremserMethodError.invalidTargetRatio
        }

        let targetRemaining =
            input.targetOutletSoluteRatio / input.inletSoluteRatio

        if input.operatingFactor < 1 {
            let infiniteStageRemaining = 1 - input.operatingFactor
            guard targetRemaining > infiniteStageRemaining + unityTolerance else {
                throw KremserMethodError.infeasibleTargetForFactor
            }
        }

        let continuousStages: Double
        let caseDescription: String

        if abs(input.operatingFactor - 1) <= unityTolerance {
            continuousStages = 1 / targetRemaining - 1
            caseDescription =
                "Unity-factor limit applied: remaining fraction = 1/(N + 1)."
        } else {
            let argument =
                1 + (input.operatingFactor - 1) / targetRemaining
            guard argument > 0 else {
                throw KremserMethodError.numericalFailure
            }

            continuousStages =
                log(argument) / log(input.operatingFactor) - 1
            caseDescription = "General Kremser factor expression applied."
        }

        guard continuousStages.isFinite, continuousStages > 0 else {
            throw KremserMethodError.numericalFailure
        }

        let wholeStages =
            max(1, Int(ceil(continuousStages - 1.0e-12)))

        let achievedRemaining: Double

        if abs(input.operatingFactor - 1) <= unityTolerance {
            achievedRemaining = 1 / Double(wholeStages + 1)
        } else {
            let denominator =
                pow(input.operatingFactor, Double(wholeStages + 1)) - 1
            guard denominator.isFinite, abs(denominator) > unityTolerance else {
                throw KremserMethodError.numericalFailure
            }
            achievedRemaining = (input.operatingFactor - 1) / denominator
        }

        let achievedOutlet = input.inletSoluteRatio * achievedRemaining

        guard achievedRemaining.isFinite,
              achievedRemaining > 0,
              achievedRemaining < 1,
              achievedOutlet.isFinite else {
            throw KremserMethodError.numericalFailure
        }

        return KremserMethodResult(
            continuousIdealStageCount: continuousStages,
            requiredWholeStageCount: wholeStages,
            achievedOutletSoluteRatio: achievedOutlet,
            targetRemovalFraction: 1 - targetRemaining,
            achievedRemovalFraction: 1 - achievedRemaining,
            achievedRemainingFraction: achievedRemaining,
            factorDescription: input.operation.factorName,
            limitingCaseDescription: caseDescription,
            modelName: "Ideal-stage Kremser method with a lean entering carrier phase"
        )
    }
}
