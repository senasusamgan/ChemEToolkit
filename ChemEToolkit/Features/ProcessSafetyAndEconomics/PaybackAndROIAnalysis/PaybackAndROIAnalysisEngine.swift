struct PaybackAndROIAnalysisEngine:
    Sendable {

    func calculate(
        _ input:
            PaybackAndROIAnalysisInput
    ) throws
        -> PaybackAndROIAnalysisResult {

        let values = [
            input.initialInvestment,
            input.annualRevenue,
            input.annualCashOperatingCost,
            input.annualDepreciation,
            input.incomeTaxRateFraction,
            input.salvageValue,
            input.projectLifeYears
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw PaybackAndROIAnalysisError
                .nonFiniteInput
        }

        guard input.initialInvestment > 0 else {
            throw PaybackAndROIAnalysisError
                .nonPositiveInitialInvestment
        }

        let nonnegativeValues = [
            input.annualRevenue,
            input.annualCashOperatingCost,
            input.annualDepreciation,
            input.salvageValue
        ]

        guard
            nonnegativeValues.allSatisfy({
                $0 >= 0
            })
        else {
            throw PaybackAndROIAnalysisError
                .negativeFinancialInput
        }

        guard
            input.incomeTaxRateFraction >= 0,
            input.incomeTaxRateFraction <= 1
        else {
            throw PaybackAndROIAnalysisError
                .invalidTaxRate
        }

        guard
            input.salvageValue
            <= input.initialInvestment
        else {
            throw PaybackAndROIAnalysisError
                .invalidSalvageValue
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
            throw PaybackAndROIAnalysisError
                .invalidProjectLife
        }

        let life =
            Int(roundedLife)

        let earningsBeforeTax =
            input.annualRevenue
            - input.annualCashOperatingCost
            - input.annualDepreciation

        let incomeTax =
            earningsBeforeTax > 0
            ? earningsBeforeTax
                * input.incomeTaxRateFraction
            : 0

        let netIncome =
            earningsBeforeTax
            - incomeTax

        let afterTaxCashFlow =
            netIncome
            + input.annualDepreciation

        let simplePayback =
            afterTaxCashFlow > 0
            ? input.initialInvestment
                / afterTaxCashFlow
            : nil

        let averageInvestment =
            (
                input.initialInvestment
                + input.salvageValue
            )
            / 2

        let accountingROI =
            averageInvestment > 0
            ? netIncome
                / averageInvestment
            : 0

        let cumulativeCashFlow =
            afterTaxCashFlow
            * Double(life)
            + input.salvageValue

        let recovered =
            cumulativeCashFlow
            >= input.initialInvestment

        let results = [
            earningsBeforeTax,
            incomeTax,
            netIncome,
            afterTaxCashFlow,
            averageInvestment,
            accountingROI,
            cumulativeCashFlow
        ]

        guard
            results.allSatisfy(\.isFinite),
            incomeTax >= 0,
            averageInvestment > 0
        else {
            throw PaybackAndROIAnalysisError
                .numericalFailure
        }

        if let simplePayback {
            guard
                simplePayback.isFinite,
                simplePayback >= 0
            else {
                throw PaybackAndROIAnalysisError
                    .numericalFailure
            }
        }

        return .init(
            projectLifeYears:
                life,
            earningsBeforeTax:
                earningsBeforeTax,
            incomeTax:
                incomeTax,
            annualNetIncome:
                netIncome,
            annualAfterTaxCashFlow:
                afterTaxCashFlow,
            simplePaybackYears:
                simplePayback,
            averageInvestment:
                averageInvestment,
            accountingROIFraction:
                accountingROI,
            cumulativeAfterTaxCashFlow:
                cumulativeCashFlow,
            investmentRecoveredWithinLife:
                recovered,
            modelName:
                "Uniform annual after-tax cash-flow, simple payback and accounting ROI",
            limitationDescription:
                "Simple payback and accounting ROI ignore the time value of money. Tax treatment is simplified: losses receive no tax credit, and depreciation and revenue are assumed constant each year."
        )
    }
}
