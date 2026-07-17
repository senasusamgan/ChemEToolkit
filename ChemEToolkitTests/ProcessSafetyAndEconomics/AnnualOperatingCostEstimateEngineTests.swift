import Testing
@testable import ChemEToolkit

@Suite("Annual Operating Cost Estimate Engine")
struct AnnualOperatingCostEstimateEngineTests {
    private let engine =
        AnnualOperatingCostEstimateEngine()

    @Test("Combines annual operating-cost components")
    func annualCost() throws {
        let result = try engine.calculate(
            .init(
                rawMaterialCost: 4_000_000,
                utilityCost: 1_200_000,
                operatingLaborCost: 1_000_000,
                maintenanceCost: 600_000,
                wasteTreatmentCost: 300_000,
                laboratoryAndQualityCost: 200_000,
                plantOverheadFractionOfLaborAndMaintenance:
                    0.6,
                insuranceAndTaxFractionOfFixedCapital:
                    0.02,
                fixedCapitalInvestment:
                    20_000_000,
                annualProduction: 50_000
            )
        )

        #expect(
            result.directCashOperatingCost
            == 7300000
        )

        #expect(
            result.plantOverheadCost
            == 960000
        )

        #expect(
            result.insuranceAndTaxCost
            == 400000
        )

        #expect(
            result.totalAnnualOperatingCost
            == 8660000
        )

        #expect(
            abs(
                result.unitProductionCost
                - 173.19999999999999
            ) < 1e-12
        )

        #expect(
            result.largestCostCategory
            == "Raw materials"
        )
    }

    @Test("Zero annual cost produces zero unit cost")
    func zeroCost() throws {
        let result = try engine.calculate(
            .init(
                rawMaterialCost: 0,
                utilityCost: 0,
                operatingLaborCost: 0,
                maintenanceCost: 0,
                wasteTreatmentCost: 0,
                laboratoryAndQualityCost: 0,
                plantOverheadFractionOfLaborAndMaintenance:
                    0,
                insuranceAndTaxFractionOfFixedCapital:
                    0,
                fixedCapitalInvestment: 0,
                annualProduction: 100
            )
        )

        #expect(
            result.totalAnnualOperatingCost
            == 0
        )

        #expect(result.unitProductionCost == 0)
    }

    @Test("Rejects invalid operating-cost fraction")
    func validation() {
        #expect(
            throws:
                AnnualOperatingCostEstimateError
                    .fractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    rawMaterialCost: 4_000_000,
                    utilityCost: 1_200_000,
                    operatingLaborCost: 1_000_000,
                    maintenanceCost: 600_000,
                    wasteTreatmentCost: 300_000,
                    laboratoryAndQualityCost: 200_000,
                    plantOverheadFractionOfLaborAndMaintenance:
                        1.2,
                    insuranceAndTaxFractionOfFixedCapital:
                        0.02,
                    fixedCapitalInvestment:
                        20_000_000,
                    annualProduction: 50_000
                )
            )
        }
    }
}
