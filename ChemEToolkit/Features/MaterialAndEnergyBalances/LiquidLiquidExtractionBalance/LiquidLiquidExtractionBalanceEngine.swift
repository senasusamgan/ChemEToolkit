struct LiquidLiquidExtractionBalanceEngine:
    Sendable {

    func calculate(
        _ input:
            LiquidLiquidExtractionBalanceInput
    ) throws
        -> LiquidLiquidExtractionBalanceResult {

        let values = [
            input.feedSolutionMass,
            input.feedSoluteMassFraction,
            input.pureSolventMass,
            input.distributionCoefficient
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LiquidLiquidExtractionBalanceError
                .nonFiniteInput
        }

        guard input.feedSolutionMass > 0 else {
            throw LiquidLiquidExtractionBalanceError
                .nonPositiveFeedMass
        }

        guard
            input.feedSoluteMassFraction >= 0,
            input.feedSoluteMassFraction < 1
        else {
            throw LiquidLiquidExtractionBalanceError
                .invalidFeedFraction
        }

        guard input.pureSolventMass >= 0 else {
            throw LiquidLiquidExtractionBalanceError
                .negativeSolventMass
        }

        guard input.distributionCoefficient >= 0 else {
            throw LiquidLiquidExtractionBalanceError
                .negativeDistributionCoefficient
        }

        let initialSolute =
            input.feedSolutionMass
            * input.feedSoluteMassFraction

        let carrierMass =
            input.feedSolutionMass
            - initialSolute

        let denominator =
            carrierMass
            + input.distributionCoefficient
                * input.pureSolventMass

        let raffinateRatio =
            denominator > 0
            ? initialSolute / denominator
            : 0

        let extractRatio =
            input.distributionCoefficient
            * raffinateRatio

        let raffinateSolute =
            raffinateRatio
            * carrierMass

        let extractSolute =
            extractRatio
            * input.pureSolventMass

        let raffinateTotal =
            carrierMass
            + raffinateSolute

        let extractTotal =
            input.pureSolventMass
            + extractSolute

        let extraction =
            initialSolute > 0
            ? extractSolute / initialSolute
            : 0

        let outputs = [
            carrierMass,
            initialSolute,
            raffinateSolute,
            extractSolute,
            raffinateTotal,
            extractTotal,
            raffinateRatio,
            extractRatio,
            extraction
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            outputs.allSatisfy({ $0 >= -1e-12 }),
            extraction <= 1 + 1e-12
        else {
            throw LiquidLiquidExtractionBalanceError
                .numericalFailure
        }

        return .init(
            feedCarrierMass:
                carrierMass,
            initialSoluteMass:
                initialSolute,
            raffinateSoluteMass:
                max(0, raffinateSolute),
            extractSoluteMass:
                max(0, extractSolute),
            raffinateTotalMass:
                raffinateTotal,
            extractTotalMass:
                extractTotal,
            raffinateSoluteRatio:
                raffinateRatio,
            extractSoluteRatio:
                extractRatio,
            extractionFraction:
                min(1, max(0, extraction)),
            modelName:
                "Single equilibrium-stage dilute liquid–liquid extraction balance",
            limitationDescription:
                "Assumes immiscible carrier and solvent, dilute solute loading and a constant distribution coefficient defined as extract solute ratio divided by raffinate solute ratio."
        )
    }
}
