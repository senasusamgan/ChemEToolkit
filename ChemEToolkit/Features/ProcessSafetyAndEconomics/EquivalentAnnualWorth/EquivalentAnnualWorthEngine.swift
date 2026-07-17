import Foundation

struct EquivalentAnnualWorthEngine:
    Sendable {

    func calculate(
        _ input:
            EquivalentAnnualWorthInput
    ) throws
        -> EquivalentAnnualWorthResult {

        let values = [
            input.initialInvestment,
            input.annualNetCashFlow,
            input.terminalValue,
            input.projectLifeYears,
            input.discountRateFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EquivalentAnnualWorthError
                .nonFiniteInput
        }

        guard input.initialInvestment > 0 else {
            throw EquivalentAnnualWorthError
                .nonPositiveInitialInvestment
        }

        guard input.terminalValue >= 0 else {
            throw EquivalentAnnualWorthError
                .negativeTerminalValue
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
            throw EquivalentAnnualWorthError
                .invalidProjectLife
        }

        guard input.discountRateFraction > -1 else {
            throw EquivalentAnnualWorthError
                .invalidDiscountRate
        }

        let life =
            Int(roundedLife)

        let rate =
            input.discountRateFraction

        let capitalRecoveryFactor:
            Double

        let sinkingFundFactor:
            Double

        if abs(rate) < 1e-14 {
            capitalRecoveryFactor =
                1 / Double(life)

            sinkingFundFactor =
                1 / Double(life)
        } else {
            let factor =
                pow(
                    1 + rate,
                    Double(life)
                )

            let denominator =
                factor - 1

            guard denominator != 0 else {
                throw EquivalentAnnualWorthError
                    .numericalFailure
            }

            capitalRecoveryFactor =
                rate * factor
                / denominator

            sinkingFundFactor =
                rate
                / denominator
        }

        let annualizedInvestment =
            input.initialInvestment
            * capitalRecoveryFactor

        let annualizedTerminal =
            input.terminalValue
            * sinkingFundFactor

        let annualWorth =
            input.annualNetCashFlow
            + annualizedTerminal
            - annualizedInvestment

        let presentWorth =
            annualWorth
            / capitalRecoveryFactor

        let description: String

        if annualWorth > 0 {
            description =
                "Positive annual worth: the project creates equivalent annual economic value at the selected discount rate."
        } else if annualWorth < 0 {
            description =
                "Negative annual worth: the project does not recover its annualized capital charge."
        } else {
            description =
                "Zero annual worth: the project is at annualized break-even."
        }

        let results = [
            capitalRecoveryFactor,
            sinkingFundFactor,
            annualizedInvestment,
            annualizedTerminal,
            annualWorth,
            presentWorth
        ]

        guard
            results.allSatisfy(\.isFinite),
            capitalRecoveryFactor > 0,
            sinkingFundFactor > 0,
            annualizedInvestment > 0,
            annualizedTerminal >= 0
        else {
            throw EquivalentAnnualWorthError
                .numericalFailure
        }

        return .init(
            projectLifeYears:
                life,
            capitalRecoveryFactor:
                capitalRecoveryFactor,
            sinkingFundFactor:
                sinkingFundFactor,
            annualizedInitialInvestment:
                annualizedInvestment,
            annualizedTerminalValue:
                annualizedTerminal,
            equivalentAnnualWorth:
                annualWorth,
            presentWorth:
                presentWorth,
            economicDescription:
                description,
            modelName:
                "Equivalent annual worth from capital-recovery and sinking-fund factors",
            limitationDescription:
                "Assumes uniform annual cash flow, one initial investment and one terminal value. Taxes, escalation, construction timing and changing annual cash flows are excluded."
        )
    }
}
