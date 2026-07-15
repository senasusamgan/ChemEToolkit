struct CrosscurrentLiquidLiquidExtractionEngine:
    Sendable {

    private let integerTolerance =
        1.0e-9

    private let zeroTolerance =
        1.0e-12

    func calculate(
        _ input:
            CrosscurrentLiquidLiquidExtractionInput
    ) throws
        -> CrosscurrentLiquidLiquidExtractionResult {

        let values = [
            input.raffinateCarrierFlowRate,
            input.totalFreshSolventFlowRate,
            input.feedSoluteRatio,
            input.freshSolventSoluteRatio,
            input.distributionCoefficient,
            input.numberOfStages
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                CrosscurrentLiquidLiquidExtractionError
                    .nonFiniteInput
        }

        guard
            input.raffinateCarrierFlowRate > 0,
            input.totalFreshSolventFlowRate > 0,
            input.distributionCoefficient > 0
        else {
            throw
                CrosscurrentLiquidLiquidExtractionError
                    .nonPositiveProperty
        }

        guard
            input.feedSoluteRatio >= 0,
            input.freshSolventSoluteRatio >= 0
        else {
            throw
                CrosscurrentLiquidLiquidExtractionError
                    .negativeSoluteRatio
        }

        let roundedStages =
            input.numberOfStages.rounded()

        guard
            abs(
                input.numberOfStages
                - roundedStages
            ) <= integerTolerance,
            roundedStages >= 1,
            roundedStages <= 100
        else {
            throw
                CrosscurrentLiquidLiquidExtractionError
                    .invalidStageCount
        }

        guard
            input.distributionCoefficient
            * input.feedSoluteRatio
            >= input.freshSolventSoluteRatio
            - zeroTolerance
        else {
            throw
                CrosscurrentLiquidLiquidExtractionError
                    .reverseTransferAtFeed
        }

        let stages = Int(roundedStages)

        let solventPerStage =
            input.totalFreshSolventFlowRate
            / Double(stages)

        let extractionFactor =
            input.distributionCoefficient
            * solventPerStage
            / input.raffinateCarrierFlowRate

        var currentRaffinate =
            input.feedSoluteRatio

        var raffinateRatios: [Double] = []
        var extractRatios: [Double] = []

        for _ in 0..<stages {
            let nextRaffinate =
                (
                    input.raffinateCarrierFlowRate
                    * currentRaffinate
                    + solventPerStage
                    * input.freshSolventSoluteRatio
                )
                / (
                    input.raffinateCarrierFlowRate
                    + solventPerStage
                    * input.distributionCoefficient
                )

            let extractRatio =
                input.distributionCoefficient
                * nextRaffinate

            guard
                nextRaffinate.isFinite,
                extractRatio.isFinite,
                nextRaffinate >= 0,
                extractRatio >= 0,
                nextRaffinate
                <= currentRaffinate
                + zeroTolerance
            else {
                throw
                    CrosscurrentLiquidLiquidExtractionError
                        .numericalFailure
            }

            raffinateRatios.append(
                nextRaffinate
            )

            extractRatios.append(
                extractRatio
            )

            currentRaffinate =
                nextRaffinate
        }

        let remainingFraction =
            input.feedSoluteRatio
            > zeroTolerance
            ? currentRaffinate
                / input.feedSoluteRatio
            : 0

        let removalFraction =
            input.feedSoluteRatio
            > zeroTolerance
            ? 1 - remainingFraction
            : 0

        let totalTransferRate =
            input.raffinateCarrierFlowRate
            * (
                input.feedSoluteRatio
                - currentRaffinate
            )

        guard
            remainingFraction.isFinite,
            removalFraction.isFinite,
            totalTransferRate.isFinite,
            extractionFactor > 0
        else {
            throw
                CrosscurrentLiquidLiquidExtractionError
                    .numericalFailure
        }

        return
            CrosscurrentLiquidLiquidExtractionResult(
                numberOfStages: stages,
                solventFlowPerStage:
                    solventPerStage,
                extractionFactorPerStage:
                    extractionFactor,
                finalRaffinateSoluteRatio:
                    currentRaffinate,
                finalStageExtractSoluteRatio:
                    extractRatios.last ?? 0,
                soluteRemainingFraction:
                    remainingFraction,
                overallRemovalFraction:
                    removalFraction,
                totalTransferRate:
                    totalTransferRate,
                raffinateRatiosByStage:
                    raffinateRatios,
                extractRatiosByStage:
                    extractRatios,
                modelName:
                    "Equal-solvent crosscurrent extraction with fresh solvent at every equilibrium stage"
            )
    }
}
