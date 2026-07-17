import Foundation

struct NetPresentValueAnalysisEngine:
    Sendable {

    func calculate(
        _ input:
            NetPresentValueAnalysisInput
    ) throws
        -> NetPresentValueAnalysisResult {

        let values = [
            input.initialInvestment,
            input.annualNetCashFlow,
            input.projectLifeYears,
            input.discountRateFraction,
            input.terminalValue
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw NetPresentValueAnalysisError
                .nonFiniteInput
        }

        guard input.initialInvestment > 0 else {
            throw NetPresentValueAnalysisError
                .nonPositiveInitialInvestment
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
            throw NetPresentValueAnalysisError
                .invalidProjectLife
        }

        guard input.discountRateFraction > -1 else {
            throw NetPresentValueAnalysisError
                .invalidDiscountRate
        }

        guard input.terminalValue >= 0 else {
            throw NetPresentValueAnalysisError
                .negativeTerminalValue
        }

        let life =
            Int(roundedLife)

        var presentValueCashFlows =
            0.0

        var cumulativeDiscountedCashFlow =
            -input.initialInvestment

        var discountedPayback:
            Double?

        for year in 1...life {
            let discountFactor =
                pow(
                    1
                    + input.discountRateFraction,
                    Double(year)
                )

            let discountedCashFlow =
                input.annualNetCashFlow
                / discountFactor

            presentValueCashFlows +=
                discountedCashFlow

            let previousCumulative =
                cumulativeDiscountedCashFlow

            cumulativeDiscountedCashFlow +=
                discountedCashFlow

            if
                discountedPayback == nil,
                previousCumulative < 0,
                cumulativeDiscountedCashFlow >= 0,
                discountedCashFlow > 0
            {
                let fraction =
                    -previousCumulative
                    / discountedCashFlow

                discountedPayback =
                    Double(year - 1)
                    + fraction
            }
        }

        let terminalDiscountFactor =
            pow(
                1
                + input.discountRateFraction,
                Double(life)
            )

        let presentValueTerminal =
            input.terminalValue
            / terminalDiscountFactor

        let totalPresentValueInflows =
            presentValueCashFlows
            + presentValueTerminal

        let npv =
            totalPresentValueInflows
            - input.initialInvestment

        let profitabilityIndex =
            totalPresentValueInflows
            / input.initialInvestment

        let description: String

        if npv > 0 {
            description =
                "Positive NPV: estimated discounted inflows exceed the initial investment."
        } else if npv < 0 {
            description =
                "Negative NPV: estimated discounted inflows do not recover the initial investment at this discount rate."
        } else {
            description =
                "Zero NPV: the project is at the selected discounted break-even point."
        }

        let results = [
            presentValueCashFlows,
            presentValueTerminal,
            npv,
            profitabilityIndex
        ]

        guard
            results.allSatisfy(\.isFinite),
            presentValueTerminal >= 0,
            profitabilityIndex.isFinite
        else {
            throw NetPresentValueAnalysisError
                .numericalFailure
        }

        if let discountedPayback {
            guard
                discountedPayback.isFinite,
                discountedPayback >= 0,
                discountedPayback <= Double(life)
            else {
                throw NetPresentValueAnalysisError
                    .numericalFailure
            }
        }

        return .init(
            projectLifeYears:
                life,
            presentValueOfAnnualCashFlows:
                presentValueCashFlows,
            presentValueOfTerminalValue:
                presentValueTerminal,
            netPresentValue:
                npv,
            profitabilityIndex:
                profitabilityIndex,
            discountedPaybackYears:
                discountedPayback,
            valueCreationDescription:
                description,
            modelName:
                "Uniform annual-cash-flow discounted cash-flow analysis",
            limitationDescription:
                "Assumes one constant annual net cash flow occurring at each year-end plus an optional terminal value. Escalation, taxes, depreciation, construction timing and irregular cash flows must be modeled separately."
        )
    }
}
