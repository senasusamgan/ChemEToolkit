struct ExtractionDistributionSelectivityEngine:
    Sendable {

    func calculate(
        _ input:
            ExtractionDistributionSelectivityInput
    ) throws
        -> ExtractionDistributionSelectivityResult {

        let values = [
            input.feedCarrierFlow,
            input.solventCarrierFlow,
            input.targetDistributionCoefficient,
            input.impurityDistributionCoefficient
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ExtractionDistributionSelectivityError
                .nonFiniteInput
        }

        guard
            input.feedCarrierFlow > 0,
            input.solventCarrierFlow > 0
        else {
            throw ExtractionDistributionSelectivityError
                .nonPositiveFlow
        }

        guard
            input.targetDistributionCoefficient > 0,
            input.impurityDistributionCoefficient > 0
        else {
            throw ExtractionDistributionSelectivityError
                .nonPositiveDistributionCoefficient
        }

        let solventFeedRatio =
            input.solventCarrierFlow
            / input.feedCarrierFlow

        let targetFactor =
            input.targetDistributionCoefficient
            * solventFeedRatio

        let impurityFactor =
            input.impurityDistributionCoefficient
            * solventFeedRatio

        let targetExtracted =
            targetFactor
            / (1 + targetFactor)

        let impurityExtracted =
            impurityFactor
            / (1 + impurityFactor)

        let distributionSelectivity =
            input.targetDistributionCoefficient
            / input.impurityDistributionCoefficient

        let extractedSelectivity =
            targetExtracted
            / impurityExtracted

        let description: String

        if distributionSelectivity > 1 {
            description =
                "Solvent favors the target solute"
        } else if distributionSelectivity < 1 {
            description =
                "Solvent favors the impurity"
        } else {
            description =
                "No distribution selectivity"
        }

        let outputs = [
            solventFeedRatio,
            targetFactor,
            impurityFactor,
            targetExtracted,
            impurityExtracted,
            distributionSelectivity,
            extractedSelectivity
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            targetExtracted > 0,
            targetExtracted < 1,
            impurityExtracted > 0,
            impurityExtracted < 1
        else {
            throw ExtractionDistributionSelectivityError
                .numericalFailure
        }

        return .init(
            solventToFeedRatio:
                solventFeedRatio,
            targetExtractionFactor:
                targetFactor,
            impurityExtractionFactor:
                impurityFactor,
            targetExtractedFraction:
                targetExtracted,
            impurityExtractedFraction:
                impurityExtracted,
            distributionSelectivity:
                distributionSelectivity,
            extractedFractionSelectivity:
                extractedSelectivity,
            separationDescription:
                description,
            modelName:
                "Single-stage distribution and extraction selectivity",
            limitationDescription:
                "Uses Ei = Ki(S/F)/[1 + Ki(S/F)] for dilute solutes, fresh solvent and immiscible carrier phases."
        )
    }
}
