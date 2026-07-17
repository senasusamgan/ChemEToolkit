struct BreakEvenProductionAnalysisEngine:
    Sendable {

    func calculate(
        _ input:
            BreakEvenProductionAnalysisInput
    ) throws
        -> BreakEvenProductionAnalysisResult {

        let values = [
            input.annualFixedCost,
            input.sellingPricePerUnit,
            input.variableCostPerUnit,
            input.expectedAnnualProduction,
            input.maximumAnnualCapacity
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BreakEvenProductionAnalysisError
                .nonFiniteInput
        }

        guard input.annualFixedCost >= 0 else {
            throw BreakEvenProductionAnalysisError
                .negativeFixedCost
        }

        guard input.sellingPricePerUnit > 0 else {
            throw BreakEvenProductionAnalysisError
                .nonPositiveSellingPrice
        }

        guard
            input.variableCostPerUnit >= 0,
            input.sellingPricePerUnit
                > input.variableCostPerUnit
        else {
            throw BreakEvenProductionAnalysisError
                .invalidContributionMargin
        }

        guard
            input.expectedAnnualProduction >= 0
        else {
            throw BreakEvenProductionAnalysisError
                .negativeExpectedProduction
        }

        guard
            input.maximumAnnualCapacity > 0
        else {
            throw BreakEvenProductionAnalysisError
                .nonPositiveMaximumCapacity
        }

        let contributionMargin =
            input.sellingPricePerUnit
            - input.variableCostPerUnit

        let breakEvenProduction =
            input.annualFixedCost
            / contributionMargin

        let breakEvenRevenue =
            breakEvenProduction
            * input.sellingPricePerUnit

        let breakEvenCapacityFraction =
            breakEvenProduction
            / input.maximumAnnualCapacity

        let expectedProfit =
            contributionMargin
            * input.expectedAnnualProduction
            - input.annualFixedCost

        let marginOfSafetyUnits =
            input.expectedAnnualProduction
            - breakEvenProduction

        let marginOfSafetyFraction =
            input.expectedAnnualProduction > 0
            ? marginOfSafetyUnits
                / input.expectedAnnualProduction
            : 0

        let description: String

        if expectedProfit > 0 {
            description =
                "Expected production is above break-even and produces a positive annual contribution after fixed cost."
        } else if expectedProfit < 0 {
            description =
                "Expected production is below break-even."
        } else {
            description =
                "Expected production is exactly at break-even."
        }

        let results = [
            contributionMargin,
            breakEvenProduction,
            breakEvenRevenue,
            breakEvenCapacityFraction,
            expectedProfit,
            marginOfSafetyUnits,
            marginOfSafetyFraction
        ]

        guard
            results.allSatisfy(\.isFinite),
            contributionMargin > 0,
            breakEvenProduction >= 0,
            breakEvenRevenue >= 0,
            breakEvenCapacityFraction >= 0
        else {
            throw BreakEvenProductionAnalysisError
                .numericalFailure
        }

        return .init(
            contributionMarginPerUnit:
                contributionMargin,
            breakEvenProduction:
                breakEvenProduction,
            breakEvenSalesRevenue:
                breakEvenRevenue,
            breakEvenCapacityFraction:
                breakEvenCapacityFraction,
            expectedAnnualProfit:
                expectedProfit,
            expectedMarginOfSafetyUnits:
                marginOfSafetyUnits,
            expectedMarginOfSafetyFraction:
                marginOfSafetyFraction,
            breakEvenIsWithinCapacity:
                breakEvenProduction
                <= input.maximumAnnualCapacity,
            profitabilityDescription:
                description,
            modelName:
                "Linear cost-volume-profit break-even analysis",
            limitationDescription:
                "Assumes constant selling price, variable cost per unit and annual fixed cost. Product mix, nonlinear capacity effects, taxes and the time value of money are excluded."
        )
    }
}
