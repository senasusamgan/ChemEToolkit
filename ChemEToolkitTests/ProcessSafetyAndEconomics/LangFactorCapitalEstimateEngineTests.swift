import Testing
@testable import ChemEToolkit

@Suite("Lang-Factor Capital Estimate Engine")
struct LangFactorCapitalEstimateEngineTests {
    private let engine =
        LangFactorCapitalEstimateEngine()

    @Test("Calculates fixed and total capital")
    func capitalEstimate() throws {
        let result = try engine.calculate(
            .init(
                purchasedEquipmentCost:
                    5_000_000,
                langFactor: 4.74,
                landCost: 500_000,
                workingCapitalFractionOfFixedCapital:
                    0.15,
                startupExpenseFractionOfFixedCapital:
                    0.05
            )
        )

        #expect(
            abs(
                result.fixedCapitalInvestment
                - 23700000
            ) < 1e-8
        )

        #expect(
            abs(
                result.workingCapital
                - 3555000
            ) < 1e-8
        )

        #expect(
            abs(
                result.startupExpense
                - 1185000
            ) < 1e-8
        )

        #expect(
            abs(
                result.totalCapitalInvestment
                - 28940000
            ) < 1e-8
        )
    }

    @Test("Unit Lang factor leaves equipment as fixed capital")
    func unitFactor() throws {
        let result = try engine.calculate(
            .init(
                purchasedEquipmentCost: 100,
                langFactor: 1,
                landCost: 0,
                workingCapitalFractionOfFixedCapital:
                    0,
                startupExpenseFractionOfFixedCapital:
                    0
            )
        )

        #expect(
            result.fixedCapitalInvestment
            == 100
        )

        #expect(
            result.langFactorAddedCost
            == 0
        )

        #expect(
            result.totalCapitalInvestment
            == 100
        )
    }

    @Test("Rejects invalid capital fractions")
    func validation() {
        #expect(
            throws:
                LangFactorCapitalEstimateError
                    .fractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    purchasedEquipmentCost:
                        5_000_000,
                    langFactor: 4.74,
                    landCost: 500_000,
                    workingCapitalFractionOfFixedCapital:
                        1.2,
                    startupExpenseFractionOfFixedCapital:
                        0.05
                )
            )
        }
    }
}
