import Testing
@testable import ChemEToolkit

@Suite("Economic Sensitivity Analysis Engine")
struct EconomicSensitivityAnalysisEngineTests {
    private let engine =
        EconomicSensitivityAnalysisEngine()

    @Test("Compares base and changed economic cases")
    func sensitivity() throws {
        let result = try engine.calculate(
            .init(
                baseAnnualRevenue:
                    5_000_000,
                baseAnnualOperatingCost:
                    3_000_000,
                baseCapitalInvestment:
                    10_000_000,
                revenueChangeFraction:
                    -0.1,
                operatingCostChangeFraction:
                    0.1,
                capitalChangeFraction:
                    0.05,
                projectLifeYears: 10,
                discountRateFraction:
                    0.1
            )
        )

        #expect(
            result.baseAnnualNetCashFlow
            == 2000000
        )

        #expect(
            result.scenarioAnnualNetCashFlow
            == 1199999.9999999995
        )

        #expect(
            abs(
                result.baseNetPresentValue
                - 2289134.2114093713
            ) < 1e-8
        )

        #expect(
            abs(
                result.scenarioNetPresentValue
                - -3126519.4731543809
            ) < 1e-8
        )

        #expect(
            abs(
                result.netPresentValueChange
                - -5415653.6845637523
            ) < 1e-8
        )

        #expect(
            abs(
                result.baseSimplePaybackYears!
                - 5
            ) < 1e-12
        )

        #expect(
            abs(
                result.scenarioSimplePaybackYears!
                - 8.7500000000000036
            ) < 1e-12
        )

        #expect(
            result.dominantSensitivityDriver
            == "Revenue"
        )
    }

    @Test("No changes reproduce the base case")
    func unchangedCase() throws {
        let result = try engine.calculate(
            .init(
                baseAnnualRevenue: 100,
                baseAnnualOperatingCost: 60,
                baseCapitalInvestment: 200,
                revenueChangeFraction: 0,
                operatingCostChangeFraction: 0,
                capitalChangeFraction: 0,
                projectLifeYears: 5,
                discountRateFraction: 0.1
            )
        )

        #expect(
            result.baseNetPresentValue
            == result.scenarioNetPresentValue
        )

        #expect(
            result.netPresentValueChange
            == 0
        )
    }

    @Test("Rejects scenario with negative revenue")
    func validation() {
        #expect(
            throws:
                EconomicSensitivityAnalysisError
                    .scenarioProducesNegativeRevenueOrCost
        ) {
            try engine.calculate(
                .init(
                    baseAnnualRevenue: 100,
                    baseAnnualOperatingCost: 60,
                    baseCapitalInvestment: 200,
                    revenueChangeFraction: -1.5,
                    operatingCostChangeFraction: 0,
                    capitalChangeFraction: 0,
                    projectLifeYears: 5,
                    discountRateFraction: 0.1
                )
            )
        }
    }
}
