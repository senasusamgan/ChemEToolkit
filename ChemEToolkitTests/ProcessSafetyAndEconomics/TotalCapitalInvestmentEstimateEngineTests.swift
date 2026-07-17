import Testing
@testable import ChemEToolkit

@Suite("Total Capital Investment Estimate Engine")
struct TotalCapitalInvestmentEstimateEngineTests {
    private let engine =
        TotalCapitalInvestmentEstimateEngine()

    @Test("Combines direct indirect and working capital")
    func totalInvestment() throws {
        let result = try engine.calculate(
            .init(
                purchasedEquipmentCost:
                    5_000_000,
                equipmentInstallationCost:
                    1_500_000,
                pipingCost: 1_000_000,
                instrumentationCost: 600_000,
                electricalCost: 500_000,
                buildingsAndYardCost: 800_000,
                utilitiesAndServiceFacilitiesCost:
                    900_000,
                engineeringAndConstructionCost:
                    1_400_000,
                contingencyFractionOfSubtotal:
                    0.15,
                workingCapitalFractionOfFixedCapital:
                    0.15
            )
        )

        #expect(
            result.directPlantCost
            == 10300000
        )

        #expect(
            result.indirectPlantCost
            == 1400000
        )

        #expect(
            result.subtotalBeforeContingency
            == 11700000
        )

        #expect(
            abs(
                result.contingencyCost
                - 1755000
            ) < 1e-8
        )

        #expect(
            abs(
                result.fixedCapitalInvestment
                - 13455000
            ) < 1e-8
        )

        #expect(
            abs(
                result.workingCapital
                - 2018250
            ) < 1e-8
        )

        #expect(
            abs(
                result.totalCapitalInvestment
                - 15473250
            ) < 1e-8
        )
    }

    @Test("Zero additions reduce total to equipment cost")
    func zeroAdditionalCosts() throws {
        let result = try engine.calculate(
            .init(
                purchasedEquipmentCost: 100,
                equipmentInstallationCost: 0,
                pipingCost: 0,
                instrumentationCost: 0,
                electricalCost: 0,
                buildingsAndYardCost: 0,
                utilitiesAndServiceFacilitiesCost:
                    0,
                engineeringAndConstructionCost:
                    0,
                contingencyFractionOfSubtotal:
                    0,
                workingCapitalFractionOfFixedCapital:
                    0
            )
        )

        #expect(result.directPlantCost == 100)

        #expect(
            result.fixedCapitalInvestment
            == 100
        )

        #expect(
            result.totalCapitalInvestment
            == 100
        )
    }

    @Test("Rejects negative component cost")
    func validation() {
        #expect(
            throws:
                TotalCapitalInvestmentEstimateError
                    .negativeCostComponent
        ) {
            try engine.calculate(
                .init(
                    purchasedEquipmentCost:
                        5_000_000,
                    equipmentInstallationCost:
                        -1,
                    pipingCost: 1_000_000,
                    instrumentationCost:
                        600_000,
                    electricalCost: 500_000,
                    buildingsAndYardCost:
                        800_000,
                    utilitiesAndServiceFacilitiesCost:
                        900_000,
                    engineeringAndConstructionCost:
                        1_400_000,
                    contingencyFractionOfSubtotal:
                        0.15,
                    workingCapitalFractionOfFixedCapital:
                        0.15
                )
            )
        }
    }
}
