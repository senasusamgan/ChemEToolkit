struct LangFactorCapitalEstimateEngine:
    Sendable {

    func calculate(
        _ input:
            LangFactorCapitalEstimateInput
    ) throws
        -> LangFactorCapitalEstimateResult {

        let values = [
            input.purchasedEquipmentCost,
            input.langFactor,
            input.landCost,
            input.workingCapitalFractionOfFixedCapital,
            input.startupExpenseFractionOfFixedCapital
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LangFactorCapitalEstimateError
                .nonFiniteInput
        }

        guard
            input.purchasedEquipmentCost > 0
        else {
            throw LangFactorCapitalEstimateError
                .nonPositiveEquipmentCost
        }

        guard input.langFactor >= 1 else {
            throw LangFactorCapitalEstimateError
                .langFactorBelowOne
        }

        guard input.landCost >= 0 else {
            throw LangFactorCapitalEstimateError
                .negativeLandCost
        }

        let fractions = [
            input.workingCapitalFractionOfFixedCapital,
            input.startupExpenseFractionOfFixedCapital
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw LangFactorCapitalEstimateError
                .fractionOutsideRange
        }

        let fixedCapital =
            input.purchasedEquipmentCost
            * input.langFactor

        let langAddedCost =
            fixedCapital
            - input.purchasedEquipmentCost

        let workingCapital =
            fixedCapital
            * input
                .workingCapitalFractionOfFixedCapital

        let startupExpense =
            fixedCapital
            * input
                .startupExpenseFractionOfFixedCapital

        let totalInvestment =
            fixedCapital
            + input.landCost
            + workingCapital
            + startupExpense

        let investmentRatio =
            totalInvestment
            / input.purchasedEquipmentCost

        let results = [
            fixedCapital,
            langAddedCost,
            workingCapital,
            startupExpense,
            totalInvestment,
            investmentRatio
        ]

        guard
            results.allSatisfy(\.isFinite),
            fixedCapital > 0,
            langAddedCost >= 0,
            workingCapital >= 0,
            startupExpense >= 0,
            totalInvestment > 0,
            investmentRatio >= 1
        else {
            throw LangFactorCapitalEstimateError
                .numericalFailure
        }

        return .init(
            purchasedEquipmentCost:
                input.purchasedEquipmentCost,
            fixedCapitalInvestment:
                fixedCapital,
            langFactorAddedCost:
                langAddedCost,
            landCost:
                input.landCost,
            workingCapital:
                workingCapital,
            startupExpense:
                startupExpense,
            totalCapitalInvestment:
                totalInvestment,
            totalInvestmentToEquipmentRatio:
                investmentRatio,
            modelName:
                "Preliminary Lang-factor capital-cost estimate",
            limitationDescription:
                "The Lang factor is a screening-level multiplier whose appropriate value depends on plant type, solids handling, materials and cost basis. Avoid adding costs already embedded in the selected factor."
        )
    }
}
