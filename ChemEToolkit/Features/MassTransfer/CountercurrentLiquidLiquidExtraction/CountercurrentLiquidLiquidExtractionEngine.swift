import Foundation

struct CountercurrentLiquidLiquidExtractionEngine:
    Sendable {

    private let unityTolerance =
        1.0e-10

    func calculate(
        _ input:
            CountercurrentLiquidLiquidExtractionInput
    ) throws
        -> CountercurrentLiquidLiquidExtractionResult {

        let values = [
            input.raffinateCarrierFlowRate,
            input.solventCarrierFlowRate,
            input.distributionCoefficient,
            input.feedSoluteRatio,
            input.targetRaffinateSoluteRatio,
            input.enteringSolventSoluteRatio
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                CountercurrentLiquidLiquidExtractionError
                    .nonFiniteInput
        }

        guard
            input.raffinateCarrierFlowRate > 0,
            input.solventCarrierFlowRate > 0,
            input.distributionCoefficient > 0
        else {
            throw
                CountercurrentLiquidLiquidExtractionError
                    .nonPositiveProperty
        }

        guard
            input.feedSoluteRatio >= 0,
            input.targetRaffinateSoluteRatio >= 0,
            input.enteringSolventSoluteRatio >= 0
        else {
            throw
                CountercurrentLiquidLiquidExtractionError
                    .negativeSoluteRatio
        }

        let equilibriumRaffinateLimit =
            input.enteringSolventSoluteRatio
            / input.distributionCoefficient

        let shiftedFeed =
            input.feedSoluteRatio
            - equilibriumRaffinateLimit

        let shiftedTarget =
            input.targetRaffinateSoluteRatio
            - equilibriumRaffinateLimit

        guard shiftedFeed > unityTolerance else {
            throw
                CountercurrentLiquidLiquidExtractionError
                    .noInitialExtractionDrivingForce
        }

        guard
            input.targetRaffinateSoluteRatio
            < input.feedSoluteRatio,
            shiftedTarget > unityTolerance
        else {
            throw
                CountercurrentLiquidLiquidExtractionError
                    .invalidTargetRatio
        }

        let targetRemainingFraction =
            shiftedTarget / shiftedFeed

        let extractionFactor =
            input.distributionCoefficient
            * input.solventCarrierFlowRate
            / input.raffinateCarrierFlowRate

        if extractionFactor < 1 {
            let infiniteStageRemainingFraction =
                1 - extractionFactor

            guard
                targetRemainingFraction
                > infiniteStageRemainingFraction
                + unityTolerance
            else {
                throw
                    CountercurrentLiquidLiquidExtractionError
                        .infeasibleTargetForExtractionFactor
            }
        }

        let continuousStages: Double
        let limitingDescription: String

        if abs(extractionFactor - 1)
            <= unityTolerance {

            continuousStages =
                1 / targetRemainingFraction
                - 1

            limitingDescription =
                "Unity extraction-factor limit applied: shifted remaining fraction = 1/(N + 1)."
        } else {
            let logarithmArgument =
                1
                + (
                    extractionFactor - 1
                )
                / targetRemainingFraction

            guard logarithmArgument > 0 else {
                throw
                    CountercurrentLiquidLiquidExtractionError
                        .numericalFailure
            }

            continuousStages =
                log(logarithmArgument)
                / log(extractionFactor)
                - 1

            limitingDescription =
                "General countercurrent extraction-factor expression applied."
        }

        guard
            continuousStages.isFinite,
            continuousStages > 0
        else {
            throw
                CountercurrentLiquidLiquidExtractionError
                    .numericalFailure
        }

        let requiredWholeStages =
            max(
                1,
                Int(
                    ceil(
                        continuousStages
                        - 1.0e-12
                    )
                )
            )

        let achievedRemainingFraction: Double

        if abs(extractionFactor - 1)
            <= unityTolerance {

            achievedRemainingFraction =
                1
                / Double(
                    requiredWholeStages + 1
                )
        } else {
            let denominator =
                pow(
                    extractionFactor,
                    Double(
                        requiredWholeStages + 1
                    )
                )
                - 1

            guard
                denominator.isFinite,
                abs(denominator)
                > unityTolerance
            else {
                throw
                    CountercurrentLiquidLiquidExtractionError
                        .numericalFailure
            }

            achievedRemainingFraction =
                (
                    extractionFactor - 1
                )
                / denominator
        }

        let achievedRaffinate =
            equilibriumRaffinateLimit
            + shiftedFeed
            * achievedRemainingFraction

        let solventOutlet =
            input.enteringSolventSoluteRatio
            + input.raffinateCarrierFlowRate
            / input.solventCarrierFlowRate
            * (
                input.feedSoluteRatio
                - achievedRaffinate
            )

        let targetRemovalFraction =
            (
                input.feedSoluteRatio
                - input.targetRaffinateSoluteRatio
            )
            / input.feedSoluteRatio

        let achievedRemovalFraction =
            (
                input.feedSoluteRatio
                - achievedRaffinate
            )
            / input.feedSoluteRatio

        let transferRate =
            input.raffinateCarrierFlowRate
            * (
                input.feedSoluteRatio
                - achievedRaffinate
            )

        let results = [
            extractionFactor,
            continuousStages,
            achievedRemainingFraction,
            achievedRaffinate,
            solventOutlet,
            targetRemovalFraction,
            achievedRemovalFraction,
            transferRate
        ]

        guard
            results.allSatisfy(\.isFinite),
            extractionFactor > 0,
            achievedRaffinate >= 0,
            solventOutlet >= 0,
            achievedRemovalFraction >= 0,
            achievedRemovalFraction <= 1
        else {
            throw
                CountercurrentLiquidLiquidExtractionError
                    .numericalFailure
        }

        return
            CountercurrentLiquidLiquidExtractionResult(
                extractionFactor:
                    extractionFactor,
                continuousIdealStageCount:
                    continuousStages,
                requiredWholeStageCount:
                    requiredWholeStages,
                equilibriumRaffinateLimit:
                    equilibriumRaffinateLimit,
                achievedRaffinateSoluteRatio:
                    achievedRaffinate,
                solventOutletSoluteRatio:
                    solventOutlet,
                targetRemovalFraction:
                    targetRemovalFraction,
                achievedRemovalFraction:
                    achievedRemovalFraction,
                soluteTransferRate:
                    transferRate,
                limitingCaseDescription:
                    limitingDescription,
                modelName:
                    "Ideal countercurrent extraction with immiscible carriers and Y = DX"
            )
    }
}
