import Foundation

struct InternalRateOfReturnAnalysisEngine:
    Sendable {

    private let maximumIterations =
        200

    private let npvTolerance =
        1e-8

    private let rateTolerance =
        1e-12

    func calculate(
        _ input:
            InternalRateOfReturnAnalysisInput
    ) throws
        -> InternalRateOfReturnAnalysisResult {

        let values = [
            input.initialInvestment,
            input.annualNetCashFlow,
            input.terminalValue,
            input.projectLifeYears,
            input.minimumSearchRate,
            input.maximumSearchRate
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw InternalRateOfReturnAnalysisError
                .nonFiniteInput
        }

        guard input.initialInvestment > 0 else {
            throw InternalRateOfReturnAnalysisError
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
            throw InternalRateOfReturnAnalysisError
                .invalidProjectLife
        }

        guard input.terminalValue >= 0 else {
            throw InternalRateOfReturnAnalysisError
                .negativeTerminalValue
        }

        guard
            input.minimumSearchRate > -1,
            input.minimumSearchRate
            < input.maximumSearchRate
        else {
            throw InternalRateOfReturnAnalysisError
                .invalidSearchRange
        }

        let life =
            Int(roundedLife)

        func npv(
            at rate: Double
        ) -> Double {
            var value =
                -input.initialInvestment

            for year in 1...life {
                value +=
                    input.annualNetCashFlow
                    / pow(
                        1 + rate,
                        Double(year)
                    )
            }

            value +=
                input.terminalValue
                / pow(
                    1 + rate,
                    Double(life)
                )

            return value
        }

        var lowerRate =
            input.minimumSearchRate

        var upperRate =
            input.maximumSearchRate

        var lowerNPV =
            npv(at: lowerRate)

        var upperNPV =
            npv(at: upperRate)

        guard
            lowerNPV.isFinite,
            upperNPV.isFinite
        else {
            throw InternalRateOfReturnAnalysisError
                .numericalFailure
        }

        if abs(lowerNPV) <= npvTolerance {
            return .init(
                projectLifeYears:
                    life,
                internalRateOfReturn:
                    lowerRate,
                netPresentValueAtIRR:
                    lowerNPV,
                lowerBracketRate:
                    lowerRate,
                upperBracketRate:
                    lowerRate,
                iterationCount:
                    0,
                annualCashFlowToInvestmentRatio:
                    input.annualNetCashFlow
                    / input.initialInvestment,
                resultDescription:
                    "The lower search bound is already an IRR root.",
                modelName:
                    "Bisection IRR for uniform annual cash flow and terminal value",
                limitationDescription:
                    "IRR may be nonunique for nonconventional cash-flow patterns. This module assumes one initial outflow followed by uniform annual cash flow and an optional nonnegative terminal value."
            )
        }

        if abs(upperNPV) <= npvTolerance {
            return .init(
                projectLifeYears:
                    life,
                internalRateOfReturn:
                    upperRate,
                netPresentValueAtIRR:
                    upperNPV,
                lowerBracketRate:
                    upperRate,
                upperBracketRate:
                    upperRate,
                iterationCount:
                    0,
                annualCashFlowToInvestmentRatio:
                    input.annualNetCashFlow
                    / input.initialInvestment,
                resultDescription:
                    "The upper search bound is already an IRR root.",
                modelName:
                    "Bisection IRR for uniform annual cash flow and terminal value",
                limitationDescription:
                    "IRR may be nonunique for nonconventional cash-flow patterns. This module assumes one initial outflow followed by uniform annual cash flow and an optional nonnegative terminal value."
            )
        }

        guard
            lowerNPV * upperNPV < 0
        else {
            throw InternalRateOfReturnAnalysisError
                .rootNotBracketed
        }

        var middleRate =
            0.5
            * (
                lowerRate
                + upperRate
            )

        var middleNPV =
            npv(at: middleRate)

        var iterations = 0

        while iterations < maximumIterations {
            middleRate =
                0.5
                * (
                    lowerRate
                    + upperRate
                )

            middleNPV =
                npv(at: middleRate)

            guard
                middleRate.isFinite,
                middleNPV.isFinite
            else {
                throw InternalRateOfReturnAnalysisError
                    .numericalFailure
            }

            iterations += 1

            if
                abs(middleNPV) <= npvTolerance
                || abs(
                    upperRate
                    - lowerRate
                ) <= rateTolerance
            {
                break
            }

            if lowerNPV * middleNPV < 0 {
                upperRate =
                    middleRate

                upperNPV =
                    middleNPV
            } else {
                lowerRate =
                    middleRate

                lowerNPV =
                    middleNPV
            }
        }

        guard
            middleRate.isFinite,
            middleNPV.isFinite,
            middleRate > -1
        else {
            throw InternalRateOfReturnAnalysisError
                .numericalFailure
        }

        let description =
            middleRate >= 0
            ? "The project IRR is nonnegative within the selected search interval."
            : "The project IRR is negative within the selected search interval."

        return .init(
            projectLifeYears:
                life,
            internalRateOfReturn:
                middleRate,
            netPresentValueAtIRR:
                middleNPV,
            lowerBracketRate:
                lowerRate,
            upperBracketRate:
                upperRate,
            iterationCount:
                iterations,
            annualCashFlowToInvestmentRatio:
                input.annualNetCashFlow
                / input.initialInvestment,
            resultDescription:
                description,
            modelName:
                "Bisection IRR for uniform annual cash flow and terminal value",
            limitationDescription:
                "IRR may be nonunique for nonconventional cash-flow patterns. This module assumes one initial outflow followed by uniform annual cash flow and an optional nonnegative terminal value."
        )
    }
}
