import Foundation

struct RiskReductionCostEffectivenessEngine:
    Sendable {

    func calculate(
        _ input:
            RiskReductionCostEffectivenessInput
    ) throws
        -> RiskReductionCostEffectivenessResult {

        let values = [
            input.currentAnnualizedLoss,
            input.residualAnnualizedLoss,
            input.initialRiskReductionInvestment,
            input.annualMaintenanceCost,
            input.projectLifeYears,
            input.discountRateFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RiskReductionCostEffectivenessError
                .nonFiniteInput
        }

        let nonnegative = [
            input.currentAnnualizedLoss,
            input.residualAnnualizedLoss,
            input.initialRiskReductionInvestment,
            input.annualMaintenanceCost
        ]

        guard nonnegative.allSatisfy({ $0 >= 0 }) else {
            throw RiskReductionCostEffectivenessError
                .negativeFinancialValue
        }

        guard
            input.residualAnnualizedLoss
            <= input.currentAnnualizedLoss
        else {
            throw RiskReductionCostEffectivenessError
                .residualExceedsCurrentLoss
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
            throw RiskReductionCostEffectivenessError
                .invalidProjectLife
        }

        guard input.discountRateFraction > -1 else {
            throw RiskReductionCostEffectivenessError
                .invalidDiscountRate
        }

        let life = Int(roundedLife)

        let annualBenefit =
            input.currentAnnualizedLoss
            - input.residualAnnualizedLoss

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
            annualBenefit
            * presentWorthFactor

        let presentMaintenance =
            input.annualMaintenanceCost
            * presentWorthFactor

        let totalPresentCost =
            input.initialRiskReductionInvestment
            + presentMaintenance

        let netPresentValue =
            presentBenefit
            - totalPresentCost

        let benefitCostRatio =
            totalPresentCost > 0
            ? presentBenefit / totalPresentCost
            : (
                presentBenefit > 0
                ? Double.infinity
                : 0
            )

        let annualNetBenefit =
            annualBenefit
            - input.annualMaintenanceCost

        let payback =
            annualNetBenefit > 0
            ? input.initialRiskReductionInvestment
                / annualNetBenefit
            : nil

        let favorable =
            netPresentValue >= 0

        let description =
            favorable
            ? "Discounted avoided-loss benefits meet or exceed the entered investment and maintenance costs."
            : "Discounted avoided-loss benefits are below the entered investment and maintenance costs."

        let finiteOutputs = [
            annualBenefit,
            presentBenefit,
            presentMaintenance,
            netPresentValue
        ]

        guard
            finiteOutputs.allSatisfy(\.isFinite),
            annualBenefit >= 0,
            presentBenefit >= 0,
            presentMaintenance >= 0
        else {
            throw RiskReductionCostEffectivenessError
                .numericalFailure
        }

        guard
            benefitCostRatio.isFinite
                || benefitCostRatio == Double.infinity
        else {
            throw RiskReductionCostEffectivenessError
                .numericalFailure
        }

        if let payback {
            guard
                payback.isFinite,
                payback >= 0
            else {
                throw RiskReductionCostEffectivenessError
                    .numericalFailure
            }
        }

        return .init(
            projectLifeYears:
                life,
            annualLossReduction:
                annualBenefit,
            presentValueOfLossReduction:
                presentBenefit,
            presentValueOfMaintenanceCost:
                presentMaintenance,
            netPresentValueOfRiskReduction:
                netPresentValue,
            benefitCostRatio:
                benefitCostRatio,
            simplePaybackYears:
                payback,
            economicallyFavorable:
                favorable,
            assessmentDescription:
                description,
            modelName:
                "Discounted avoided-loss benefit–cost analysis",
            limitationDescription:
                "Economic favorability does not determine whether a safety measure is legally or ethically required. Risk estimates, uncertainty, ALARP principles and mandatory safeguards must be considered separately."
        )
    }
}
