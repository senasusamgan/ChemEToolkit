struct TotalCapitalInvestmentEstimateEngine:
    Sendable {

    func calculate(
        _ input:
            TotalCapitalInvestmentEstimateInput
    ) throws
        -> TotalCapitalInvestmentEstimateResult {

        let values = [
            input.purchasedEquipmentCost,
            input.equipmentInstallationCost,
            input.pipingCost,
            input.instrumentationCost,
            input.electricalCost,
            input.buildingsAndYardCost,
            input.utilitiesAndServiceFacilitiesCost,
            input.engineeringAndConstructionCost,
            input.contingencyFractionOfSubtotal,
            input.workingCapitalFractionOfFixedCapital
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw TotalCapitalInvestmentEstimateError
                .nonFiniteInput
        }

        guard
            input.purchasedEquipmentCost > 0
        else {
            throw TotalCapitalInvestmentEstimateError
                .nonPositiveEquipmentCost
        }

        let addedCosts = [
            input.equipmentInstallationCost,
            input.pipingCost,
            input.instrumentationCost,
            input.electricalCost,
            input.buildingsAndYardCost,
            input.utilitiesAndServiceFacilitiesCost,
            input.engineeringAndConstructionCost
        ]

        guard
            addedCosts.allSatisfy({
                $0 >= 0
            })
        else {
            throw TotalCapitalInvestmentEstimateError
                .negativeCostComponent
        }

        let fractions = [
            input.contingencyFractionOfSubtotal,
            input.workingCapitalFractionOfFixedCapital
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw TotalCapitalInvestmentEstimateError
                .fractionOutsideRange
        }

        let directCost =
            input.purchasedEquipmentCost
            + input.equipmentInstallationCost
            + input.pipingCost
            + input.instrumentationCost
            + input.electricalCost
            + input.buildingsAndYardCost
            + input.utilitiesAndServiceFacilitiesCost

        let indirectCost =
            input.engineeringAndConstructionCost

        let subtotal =
            directCost
            + indirectCost

        let contingency =
            subtotal
            * input.contingencyFractionOfSubtotal

        let fixedCapital =
            subtotal
            + contingency

        let workingCapital =
            fixedCapital
            * input
                .workingCapitalFractionOfFixedCapital

        let totalInvestment =
            fixedCapital
            + workingCapital

        let fixedCapitalRatio =
            fixedCapital
            / input.purchasedEquipmentCost

        let equipmentFraction =
            input.purchasedEquipmentCost
            / totalInvestment

        let results = [
            directCost,
            indirectCost,
            subtotal,
            contingency,
            fixedCapital,
            workingCapital,
            totalInvestment,
            fixedCapitalRatio,
            equipmentFraction
        ]

        guard
            results.allSatisfy(\.isFinite),
            directCost > 0,
            indirectCost >= 0,
            subtotal > 0,
            contingency >= 0,
            fixedCapital > 0,
            workingCapital >= 0,
            totalInvestment > 0,
            fixedCapitalRatio >= 1,
            equipmentFraction > 0,
            equipmentFraction <= 1
        else {
            throw TotalCapitalInvestmentEstimateError
                .numericalFailure
        }

        return .init(
            directPlantCost:
                directCost,
            indirectPlantCost:
                indirectCost,
            subtotalBeforeContingency:
                subtotal,
            contingencyCost:
                contingency,
            fixedCapitalInvestment:
                fixedCapital,
            workingCapital:
                workingCapital,
            totalCapitalInvestment:
                totalInvestment,
            fixedCapitalToEquipmentRatio:
                fixedCapitalRatio,
            equipmentFractionOfTotalInvestment:
                equipmentFraction,
            modelName:
                "Component-based total capital investment summary",
            limitationDescription:
                "All component costs must share the same currency, date, location and estimate scope. Financing costs, land, startup, owner costs and escalation during construction are excluded unless entered within a listed component."
        )
    }
}
