struct SingleStageLiquidLiquidExtractionEngine:
    Sendable {

    private let zeroTolerance =
        1.0e-12

    func calculate(
        _ input:
            SingleStageLiquidLiquidExtractionInput
    ) throws
        -> SingleStageLiquidLiquidExtractionResult {

        let values = [
            input.raffinateCarrierFlowRate,
            input.solventCarrierFlowRate,
            input.feedSoluteRatio,
            input.enteringSolventSoluteRatio,
            input.distributionCoefficient
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                SingleStageLiquidLiquidExtractionError
                    .nonFiniteInput
        }

        guard
            input.raffinateCarrierFlowRate > 0,
            input.solventCarrierFlowRate > 0,
            input.distributionCoefficient > 0
        else {
            throw
                SingleStageLiquidLiquidExtractionError
                    .nonPositiveProperty
        }

        guard
            input.feedSoluteRatio >= 0,
            input.enteringSolventSoluteRatio >= 0
        else {
            throw
                SingleStageLiquidLiquidExtractionError
                    .negativeSoluteRatio
        }

        let denominator =
            input.raffinateCarrierFlowRate
            + input.solventCarrierFlowRate
            * input.distributionCoefficient

        let raffinateOutlet =
            (
                input.raffinateCarrierFlowRate
                * input.feedSoluteRatio
                + input.solventCarrierFlowRate
                * input.enteringSolventSoluteRatio
            )
            / denominator

        let extractOutlet =
            input.distributionCoefficient
            * raffinateOutlet

        let signedTransferRate =
            input.raffinateCarrierFlowRate
            * (
                input.feedSoluteRatio
                - raffinateOutlet
            )

        let feedSoluteRate =
            input.raffinateCarrierFlowRate
            * input.feedSoluteRatio

        let removalFraction =
            feedSoluteRate > zeroTolerance
            ? signedTransferRate
                / feedSoluteRate
            : 0

        let inletSoluteRate =
            feedSoluteRate
            + input.solventCarrierFlowRate
            * input.enteringSolventSoluteRatio

        let outletSoluteRate =
            input.raffinateCarrierFlowRate
            * raffinateOutlet
            + input.solventCarrierFlowRate
            * extractOutlet

        let residual =
            inletSoluteRate
            - outletSoluteRate

        let extractionFactor =
            input.distributionCoefficient
            * input.solventCarrierFlowRate
            / input.raffinateCarrierFlowRate

        let results = [
            raffinateOutlet,
            extractOutlet,
            signedTransferRate,
            removalFraction,
            residual,
            extractionFactor
        ]

        guard
            results.allSatisfy(\.isFinite),
            raffinateOutlet >= 0,
            extractOutlet >= 0,
            extractionFactor > 0
        else {
            throw
                SingleStageLiquidLiquidExtractionError
                    .numericalFailure
        }

        let directionDescription: String

        if abs(signedTransferRate)
            <= zeroTolerance {

            directionDescription =
                "The entering phases are at equilibrium; no net solute transfer is predicted."
        } else if signedTransferRate > 0 {
            directionDescription =
                "Solute transfers from the raffinate carrier into the extract solvent."
        } else {
            directionDescription =
                "Solute transfers from the solvent phase into the raffinate carrier."
        }

        return
            SingleStageLiquidLiquidExtractionResult(
                raffinateOutletSoluteRatio:
                    raffinateOutlet,
                extractOutletSoluteRatio:
                    extractOutlet,
                extractionFactor:
                    extractionFactor,
                signedTransferRateToExtract:
                    signedTransferRate,
                transferRateMagnitude:
                    abs(signedTransferRate),
                raffinateRemovalFraction:
                    removalFraction,
                soluteBalanceResidual:
                    residual,
                directionDescription:
                    directionDescription,
                modelName:
                    "Single equilibrium stage with immiscible carrier phases and Y = DX"
            )
    }
}
