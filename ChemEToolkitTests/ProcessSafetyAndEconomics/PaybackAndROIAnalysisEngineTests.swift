import Testing
@testable import ChemEToolkit

@Suite("Payback and ROI Analysis Engine")
struct PaybackAndROIAnalysisEngineTests {
    private let engine =
        PaybackAndROIAnalysisEngine()

    @Test("Calculates after-tax cash flow payback and ROI")
    func paybackAndROI() throws {
        let result = try engine.calculate(
            .init(
                initialInvestment:
                    10_000_000,
                annualRevenue:
                    5_000_000,
                annualCashOperatingCost:
                    2_500_000,
                annualDepreciation:
                    900_000,
                incomeTaxRateFraction:
                    0.25,
                salvageValue:
                    1_000_000,
                projectLifeYears: 10
            )
        )

        #expect(
            result.earningsBeforeTax
            == 1600000
        )

        #expect(result.incomeTax == 400000)

        #expect(
            result.annualNetIncome
            == 1200000
        )

        #expect(
            result.annualAfterTaxCashFlow
            == 2100000
        )

        #expect(
            abs(
                result.simplePaybackYears!
                - 4.7619047619047619
            ) < 1e-12
        )

        #expect(
            result.averageInvestment
            == 5500000
        )

        #expect(
            abs(
                result.accountingROIFraction
                - 0.21818181818181817
            ) < 1e-12
        )

        #expect(
            result.cumulativeAfterTaxCashFlow
            == 22000000
        )

        #expect(
            result.investmentRecoveredWithinLife
        )
    }

    @Test("No positive cash flow gives no simple payback")
    func noPayback() throws {
        let result = try engine.calculate(
            .init(
                initialInvestment: 1000,
                annualRevenue: 100,
                annualCashOperatingCost:
                    200,
                annualDepreciation: 50,
                incomeTaxRateFraction: 0.25,
                salvageValue: 0,
                projectLifeYears: 5
            )
        )

        #expect(
            result.simplePaybackYears == nil
        )

        #expect(
            !result.investmentRecoveredWithinLife
        )
    }

    @Test("Rejects invalid tax rate")
    func validation() {
        #expect(
            throws:
                PaybackAndROIAnalysisError
                    .invalidTaxRate
        ) {
            try engine.calculate(
                .init(
                    initialInvestment:
                        10_000_000,
                    annualRevenue:
                        5_000_000,
                    annualCashOperatingCost:
                        2_500_000,
                    annualDepreciation:
                        900_000,
                    incomeTaxRateFraction:
                        1.2,
                    salvageValue:
                        1_000_000,
                    projectLifeYears: 10
                )
            )
        }
    }
}
