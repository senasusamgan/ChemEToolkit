import Foundation

struct EconomicSensitivityAnalysisEngine:
    Sendable {

    func calculate(
        _ input:
            EconomicSensitivityAnalysisInput
    ) throws
        -> EconomicSensitivityAnalysisResult {

        let values = [
            input.baseAnnualRevenue,
            input.baseAnnualOperatingCost,
            input.baseCapitalInvestment,
            input.revenueChangeFraction,
            input.operatingCostChangeFraction,
            input.capitalChangeFraction,
            input.projectLifeYears,
            input.discountRateFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EconomicSensitivityAnalysisError
                .nonFiniteInput
        }

        guard
            input.baseAnnualRevenue >= 0,
            input.baseAnnualOperatingCost >= 0,
            input.baseCapitalInvestment >= 0
        else {
            throw EconomicSensitivityAnalysisError
                .negativeBaseFinancialValue
        }

        guard input.baseCapitalInvestment > 0 else {
            throw EconomicSensitivityAnalysisError
                .nonPositiveCapitalInvestment
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
            throw EconomicSensitivityAnalysisError
                .invalidProjectLife
        }

        guard input.discountRateFraction > -1 else {
            throw EconomicSensitivityAnalysisError
                .invalidDiscountRate
        }

        let scenarioRevenue =
            input.baseAnnualRevenue
            * (
                1
                + input.revenueChangeFraction
            )

        let scenarioOperatingCost =
            input.baseAnnualOperatingCost
            * (
                1
                + input.operatingCostChangeFraction
            )

        let scenarioCapital =
            input.baseCapitalInvestment
            * (
                1
                + input.capitalChangeFraction
            )

        guard
            scenarioRevenue >= 0,
            scenarioOperatingCost >= 0
        else {
            throw EconomicSensitivityAnalysisError
                .scenarioProducesNegativeRevenueOrCost
        }

        guard scenarioCapital > 0 else {
            throw EconomicSensitivityAnalysisError
                .scenarioProducesNonPositiveCapital
        }

        let life =
            Int(roundedLife)

        let baseAnnualCashFlow =
            input.baseAnnualRevenue
            - input.baseAnnualOperatingCost

        let scenarioAnnualCashFlow =
            scenarioRevenue
            - scenarioOperatingCost

        func presentValueFactor(
            rate: Double,
            years: Int
        ) -> Double {
            if abs(rate) < 1e-14 {
                return Double(years)
            }

            return (
                1
                - pow(
                    1 + rate,
                    -Double(years)
                )
            )
            / rate
        }

        let annuityFactor =
            presentValueFactor(
                rate:
                    input.discountRateFraction,
                years:
                    life
            )

        let baseNPV =
            -input.baseCapitalInvestment
            + baseAnnualCashFlow
                * annuityFactor

        let scenarioNPV =
            -scenarioCapital
            + scenarioAnnualCashFlow
                * annuityFactor

        let npvChange =
            scenarioNPV
            - baseNPV

        let npvChangeFraction:
            Double?

        if abs(baseNPV) > 1e-14 {
            npvChangeFraction =
                npvChange
                / abs(baseNPV)
        } else {
            npvChangeFraction = nil
        }

        let basePayback =
            baseAnnualCashFlow > 0
            ? input.baseCapitalInvestment
                / baseAnnualCashFlow
            : nil

        let scenarioPayback =
            scenarioAnnualCashFlow > 0
            ? scenarioCapital
                / scenarioAnnualCashFlow
            : nil

        let revenueImpact =
            abs(
                input.baseAnnualRevenue
                * input.revenueChangeFraction
                * annuityFactor
            )

        let operatingCostImpact =
            abs(
                input.baseAnnualOperatingCost
                * input.operatingCostChangeFraction
                * annuityFactor
            )

        let capitalImpact =
            abs(
                input.baseCapitalInvestment
                * input.capitalChangeFraction
            )

        let drivers = [
            (
                name: "Revenue",
                impact: revenueImpact
            ),
            (
                name: "Operating cost",
                impact: operatingCostImpact
            ),
            (
                name: "Capital investment",
                impact: capitalImpact
            )
        ]

        let dominantDriver =
            drivers.max {
                $0.impact < $1.impact
            }?.name
            ?? "None"

        let description: String

        if scenarioNPV > baseNPV {
            description =
                "Scenario economics improve relative to the base case."
        } else if scenarioNPV < baseNPV {
            description =
                "Scenario economics deteriorate relative to the base case."
        } else {
            description =
                "Scenario and base-case NPV are equal."
        }

        let results = [
            baseAnnualCashFlow,
            scenarioAnnualCashFlow,
            annuityFactor,
            baseNPV,
            scenarioNPV,
            npvChange
        ]

        guard
            results.allSatisfy(\.isFinite)
        else {
            throw EconomicSensitivityAnalysisError
                .numericalFailure
        }

        if let npvChangeFraction {
            guard npvChangeFraction.isFinite else {
                throw EconomicSensitivityAnalysisError
                    .numericalFailure
            }
        }

        if let basePayback {
            guard
                basePayback.isFinite,
                basePayback >= 0
            else {
                throw EconomicSensitivityAnalysisError
                    .numericalFailure
            }
        }

        if let scenarioPayback {
            guard
                scenarioPayback.isFinite,
                scenarioPayback >= 0
            else {
                throw EconomicSensitivityAnalysisError
                    .numericalFailure
            }
        }

        return .init(
            projectLifeYears:
                life,
            baseAnnualNetCashFlow:
                baseAnnualCashFlow,
            scenarioAnnualNetCashFlow:
                scenarioAnnualCashFlow,
            baseNetPresentValue:
                baseNPV,
            scenarioNetPresentValue:
                scenarioNPV,
            netPresentValueChange:
                npvChange,
            netPresentValueChangeFraction:
                npvChangeFraction,
            baseSimplePaybackYears:
                basePayback,
            scenarioSimplePaybackYears:
                scenarioPayback,
            dominantSensitivityDriver:
                dominantDriver,
            scenarioDescription:
                description,
            modelName:
                "Three-variable economic scenario sensitivity using uniform annual cash flow",
            limitationDescription:
                "Changes are applied simultaneously to annual revenue, annual operating cost and initial capital. Correlation, taxes, escalation, terminal value and changing yearly cash flows are excluded."
        )
    }
}
