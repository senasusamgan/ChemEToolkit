import Foundation

struct LifecycleCostAnalysisEngine:
    Sendable {

    func calculate(
        _ input:
            LifecycleCostAnalysisInput
    ) throws
        -> LifecycleCostAnalysisResult {

        let values = [
            input.initialCapitalCost,
            input.annualOperatingCost,
            input.annualMaintenanceCost,
            input.periodicReplacementCost,
            input.replacementIntervalYears,
            input.terminalSalvageValue,
            input.projectLifeYears,
            input.discountRateFraction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LifecycleCostAnalysisError
                .nonFiniteInput
        }

        let costs = [
            input.initialCapitalCost,
            input.annualOperatingCost,
            input.annualMaintenanceCost,
            input.periodicReplacementCost,
            input.terminalSalvageValue
        ]

        guard costs.allSatisfy({ $0 >= 0 }) else {
            throw LifecycleCostAnalysisError
                .negativeCost
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
            throw LifecycleCostAnalysisError
                .invalidProjectLife
        }

        let roundedInterval =
            input.replacementIntervalYears.rounded()

        guard
            abs(
                input.replacementIntervalYears
                - roundedInterval
            ) < 1e-12,
            roundedInterval >= 1,
            roundedInterval <= roundedLife
        else {
            throw LifecycleCostAnalysisError
                .invalidReplacementInterval
        }

        guard input.discountRateFraction > -1 else {
            throw LifecycleCostAnalysisError
                .invalidDiscountRate
        }

        let life = Int(roundedLife)
        let interval = Int(roundedInterval)
        let rate = input.discountRateFraction

        let annuityFactor: Double

        if abs(rate) < 1e-14 {
            annuityFactor = Double(life)
        } else {
            annuityFactor =
                (
                    1
                    - pow(
                        1 + rate,
                        -Double(life)
                    )
                )
                / rate
        }

        let pvOperating =
            input.annualOperatingCost
            * annuityFactor

        let pvMaintenance =
            input.annualMaintenanceCost
            * annuityFactor

        var pvReplacement = 0.0
        var replacementCount = 0

        var replacementYear = interval

        while replacementYear < life {
            pvReplacement +=
                input.periodicReplacementCost
                / pow(
                    1 + rate,
                    Double(replacementYear)
                )

            replacementCount += 1
            replacementYear += interval
        }

        let pvSalvage =
            input.terminalSalvageValue
            / pow(
                1 + rate,
                Double(life)
            )

        let totalLifecycleCost =
            input.initialCapitalCost
            + pvOperating
            + pvMaintenance
            + pvReplacement
            - pvSalvage

        let capitalRecoveryFactor: Double

        if abs(rate) < 1e-14 {
            capitalRecoveryFactor =
                1 / Double(life)
        } else {
            let growth =
                pow(
                    1 + rate,
                    Double(life)
                )

            capitalRecoveryFactor =
                rate
                * growth
                / (growth - 1)
        }

        let equivalentAnnualCost =
            totalLifecycleCost
            * capitalRecoveryFactor

        let categories = [
            ("Initial capital", input.initialCapitalCost),
            ("Operating", pvOperating),
            ("Maintenance", pvMaintenance),
            ("Replacement", pvReplacement)
        ]

        let dominant =
            categories.max {
                $0.1 < $1.1
            }?.0
            ?? "None"

        let outputs = [
            pvOperating,
            pvMaintenance,
            pvReplacement,
            pvSalvage,
            totalLifecycleCost,
            equivalentAnnualCost
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            pvOperating >= 0,
            pvMaintenance >= 0,
            pvReplacement >= 0,
            pvSalvage >= 0,
            equivalentAnnualCost.isFinite
        else {
            throw LifecycleCostAnalysisError
                .numericalFailure
        }

        return .init(
            projectLifeYears:
                life,
            replacementIntervalYears:
                interval,
            presentValueOfOperatingCost:
                pvOperating,
            presentValueOfMaintenanceCost:
                pvMaintenance,
            presentValueOfReplacementCost:
                pvReplacement,
            presentValueOfSalvageValue:
                pvSalvage,
            totalLifecycleCost:
                totalLifecycleCost,
            equivalentAnnualCost:
                equivalentAnnualCost,
            replacementCount:
                replacementCount,
            dominantCostCategory:
                dominant,
            modelName:
                "Discounted lifecycle cost with periodic replacement",
            limitationDescription:
                "Assumes constant annual operating and maintenance costs, regular replacement timing and one terminal salvage value. Inflation, taxes, downtime and uncertain equipment life are excluded."
        )
    }
}
