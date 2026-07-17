struct AnnualOperatingCostEstimateEngine:
    Sendable {

    func calculate(
        _ input:
            AnnualOperatingCostEstimateInput
    ) throws
        -> AnnualOperatingCostEstimateResult {

        let values = [
            input.rawMaterialCost,
            input.utilityCost,
            input.operatingLaborCost,
            input.maintenanceCost,
            input.wasteTreatmentCost,
            input.laboratoryAndQualityCost,
            input.plantOverheadFractionOfLaborAndMaintenance,
            input.insuranceAndTaxFractionOfFixedCapital,
            input.fixedCapitalInvestment,
            input.annualProduction
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AnnualOperatingCostEstimateError
                .nonFiniteInput
        }

        let costValues = [
            input.rawMaterialCost,
            input.utilityCost,
            input.operatingLaborCost,
            input.maintenanceCost,
            input.wasteTreatmentCost,
            input.laboratoryAndQualityCost,
            input.fixedCapitalInvestment
        ]

        guard
            costValues.allSatisfy({
                $0 >= 0
            })
        else {
            throw AnnualOperatingCostEstimateError
                .negativeCostComponent
        }

        let fractions = [
            input.plantOverheadFractionOfLaborAndMaintenance,
            input.insuranceAndTaxFractionOfFixedCapital
        ]

        guard
            fractions.allSatisfy({
                $0 >= 0 && $0 <= 1
            })
        else {
            throw AnnualOperatingCostEstimateError
                .fractionOutsideRange
        }

        guard input.annualProduction > 0 else {
            throw AnnualOperatingCostEstimateError
                .nonPositiveAnnualProduction
        }

        let directCashCost =
            input.rawMaterialCost
            + input.utilityCost
            + input.operatingLaborCost
            + input.maintenanceCost
            + input.wasteTreatmentCost
            + input.laboratoryAndQualityCost

        let overheadCost =
            (
                input.operatingLaborCost
                + input.maintenanceCost
            )
            * input
                .plantOverheadFractionOfLaborAndMaintenance

        let insuranceAndTax =
            input.fixedCapitalInvestment
            * input
                .insuranceAndTaxFractionOfFixedCapital

        let totalCost =
            directCashCost
            + overheadCost
            + insuranceAndTax

        let unitCost =
            totalCost
            / input.annualProduction

        let variableCost =
            input.rawMaterialCost
            + input.utilityCost
            + input.wasteTreatmentCost

        let variableFraction =
            totalCost > 0
            ? variableCost / totalCost
            : 0

        let laborMaintenanceFraction =
            totalCost > 0
            ? (
                input.operatingLaborCost
                + input.maintenanceCost
            )
                / totalCost
            : 0

        let categories = [
            (
                name: "Raw materials",
                cost: input.rawMaterialCost
            ),
            (
                name: "Utilities",
                cost: input.utilityCost
            ),
            (
                name: "Operating labor",
                cost: input.operatingLaborCost
            ),
            (
                name: "Maintenance",
                cost: input.maintenanceCost
            ),
            (
                name: "Waste treatment",
                cost: input.wasteTreatmentCost
            ),
            (
                name: "Laboratory and quality",
                cost: input.laboratoryAndQualityCost
            ),
            (
                name: "Plant overhead",
                cost: overheadCost
            ),
            (
                name: "Insurance and property tax",
                cost: insuranceAndTax
            )
        ]

        let largestCategory =
            categories.max {
                $0.cost < $1.cost
            }?.name
            ?? "None"

        let results = [
            directCashCost,
            overheadCost,
            insuranceAndTax,
            totalCost,
            unitCost,
            variableFraction,
            laborMaintenanceFraction
        ]

        guard
            results.allSatisfy(\.isFinite),
            directCashCost >= 0,
            overheadCost >= 0,
            insuranceAndTax >= 0,
            totalCost >= 0,
            unitCost >= 0,
            variableFraction >= 0,
            variableFraction <= 1,
            laborMaintenanceFraction >= 0,
            laborMaintenanceFraction <= 1
        else {
            throw AnnualOperatingCostEstimateError
                .numericalFailure
        }

        return .init(
            directCashOperatingCost:
                directCashCost,
            plantOverheadCost:
                overheadCost,
            insuranceAndTaxCost:
                insuranceAndTax,
            totalAnnualOperatingCost:
                totalCost,
            unitProductionCost:
                unitCost,
            variableCostFraction:
                variableFraction,
            laborAndMaintenanceFraction:
                laborMaintenanceFraction,
            largestCostCategory:
                largestCategory,
            modelName:
                "Component-based annual cash operating-cost estimate",
            limitationDescription:
                "All costs must share the same currency and annual basis. Depreciation, financing, income tax and product distribution are excluded unless represented by an entered component."
        )
    }
}
