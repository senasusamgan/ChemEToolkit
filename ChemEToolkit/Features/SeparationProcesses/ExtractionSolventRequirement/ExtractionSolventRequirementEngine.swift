struct ExtractionSolventRequirementEngine:
    Sendable {

    func calculate(
        _ input:
            ExtractionSolventRequirementInput
    ) throws
        -> ExtractionSolventRequirementResult {

        let values = [
            input.feedCarrierFlow,
            input.feedSoluteFraction,
            input.distributionCoefficient,
            input.targetRemovalFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ExtractionSolventRequirementError
                .nonFiniteInput
        }

        guard input.feedCarrierFlow > 0 else {
            throw ExtractionSolventRequirementError
                .nonPositiveFeedFlow
        }

        guard
            input.feedSoluteFraction >= 0,
            input.feedSoluteFraction <= 1
        else {
            throw ExtractionSolventRequirementError
                .fractionOutsideRange
        }

        guard input.distributionCoefficient > 0 else {
            throw ExtractionSolventRequirementError
                .nonPositiveDistributionCoefficient
        }

        guard
            input.targetRemovalFraction > 0,
            input.targetRemovalFraction < 1
        else {
            throw ExtractionSolventRequirementError
                .invalidRemovalFraction
        }

        let remainingFraction =
            1 - input.targetRemovalFraction

        let extractionFactor =
            1 / remainingFraction - 1

        let solventFeedRatio =
            extractionFactor
            / input.distributionCoefficient

        let solventFlow =
            input.feedCarrierFlow
            * solventFeedRatio

        let raffinateFraction =
            input.feedSoluteFraction
            * remainingFraction

        let extractFraction =
            input.distributionCoefficient
            * raffinateFraction

        let initialSolute =
            input.feedCarrierFlow
            * input.feedSoluteFraction

        let remainingSolute =
            input.feedCarrierFlow
            * raffinateFraction

        let extractedSolute =
            initialSolute
            - remainingSolute

        let outputs = [
            remainingFraction,
            extractionFactor,
            solventFeedRatio,
            solventFlow,
            raffinateFraction,
            extractFraction,
            initialSolute,
            remainingSolute,
            extractedSolute
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            solventFlow > 0,
            raffinateFraction >= 0,
            raffinateFraction <= 1,
            extractFraction >= 0,
            extractFraction <= 1
        else {
            throw ExtractionSolventRequirementError
                .numericalFailure
        }

        return .init(
            requiredSolventFlow:
                solventFlow,
            solventToFeedRatio:
                solventFeedRatio,
            extractionFactor:
                extractionFactor,
            raffinateSoluteFraction:
                raffinateFraction,
            extractSoluteFraction:
                extractFraction,
            soluteExtractedFlow:
                extractedSolute,
            soluteRemainingFlow:
                remainingSolute,
            modelName:
                "Single-stage fresh-solvent requirement",
            limitationDescription:
                "Uses fraction remaining = 1/(1 + K_DS/F) with solute-free solvent, constant K_D and immiscible carrier phases."
        )
    }
}
