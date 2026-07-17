import Foundation

struct ALARPGrossDisproportionScreeningEngine:
    Sendable {

    func calculate(
        _ input:
            ALARPGrossDisproportionScreeningInput
    ) throws
        -> ALARPGrossDisproportionScreeningResult {

        let values = [
            input.riskReductionMeasureCost,
            input.annualizedLossReduction,
            input.projectLifeYears,
            input.discountRateFraction,
            input.grossDisproportionFactor
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ALARPGrossDisproportionScreeningError
                .nonFiniteInput
        }

        guard
            input.riskReductionMeasureCost >= 0,
            input.annualizedLossReduction >= 0
        else {
            throw ALARPGrossDisproportionScreeningError
                .negativeCostOrBenefit
        }

        guard input.annualizedLossReduction > 0 else {
            throw ALARPGrossDisproportionScreeningError
                .zeroRiskReductionBenefit
        }

        let roundedLife =
            input.projectLifeYears.rounded()

        guard
            abs(
                input.projectLifeYears
                - roundedLife
            ) < 1e-12,
            roundedLife >= 1,
            roundedLife <= 100
        else {
            throw ALARPGrossDisproportionScreeningError
                .invalidProjectLife
        }

        guard input.discountRateFraction > -1 else {
            throw ALARPGrossDisproportionScreeningError
                .invalidDiscountRate
        }

        guard input.grossDisproportionFactor >= 1 else {
            throw ALARPGrossDisproportionScreeningError
                .invalidGrossDisproportionFactor
        }

        let life =
            Int(roundedLife)

        let presentWorthFactor: Double

        if abs(input.discountRateFraction) < 1e-14 {
            presentWorthFactor =
                Double(life)
        } else {
            presentWorthFactor =
                (
                    1
                    - pow(
                        1
                        + input.discountRateFraction,
                        -Double(life)
                    )
                )
                / input.discountRateFraction
        }

        let presentBenefit =
            input.annualizedLossReduction
            * presentWorthFactor

        let adjustedThreshold =
            presentBenefit
            * input.grossDisproportionFactor

        let costBenefitRatio =
            input.riskReductionMeasureCost
            / presentBenefit

        let costThresholdRatio =
            input.riskReductionMeasureCost
            / adjustedThreshold

        let grosslyDisproportionate =
            input.riskReductionMeasureCost
            > adjustedThreshold

        let recommendation =
            grosslyDisproportionate
            ? "The entered cost exceeds the benefit multiplied by the selected gross-disproportion factor."
            : "The entered cost does not exceed the selected gross-disproportion screening threshold."

        let outputs = [
            presentBenefit,
            adjustedThreshold,
            costBenefitRatio,
            costThresholdRatio
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            presentBenefit > 0,
            adjustedThreshold > 0,
            costBenefitRatio >= 0,
            costThresholdRatio >= 0
        else {
            throw ALARPGrossDisproportionScreeningError
                .numericalFailure
        }

        return .init(
            projectLifeYears:
                life,
            presentValueOfRiskReductionBenefit:
                presentBenefit,
            adjustedReasonableCostThreshold:
                adjustedThreshold,
            costToBenefitRatio:
                costBenefitRatio,
            costToAdjustedThresholdRatio:
                costThresholdRatio,
            measureCostIsGrosslyDisproportionate:
                grosslyDisproportionate,
            screeningRecommendation:
                recommendation,
            modelName:
                "Discounted gross-disproportion cost–benefit screening",
            limitationDescription:
                "This is not a legal ALARP determination. Monetized loss reduction, uncertainty, mandatory controls, good practice, ethical duties and jurisdiction-specific guidance must be considered by competent decision makers."
        )
    }
}
