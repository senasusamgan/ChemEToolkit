import Testing
@testable import ChemEToolkit

@Suite("Break-Even Production Analysis Engine")
struct BreakEvenProductionAnalysisEngineTests {
    private let engine =
        BreakEvenProductionAnalysisEngine()

    @Test("Calculates break-even production and profit")
    func breakEven() throws {
        let result = try engine.calculate(
            .init(
                annualFixedCost: 3_000_000,
                sellingPricePerUnit: 120,
                variableCostPerUnit: 70,
                expectedAnnualProduction: 80_000,
                maximumAnnualCapacity: 120_000
            )
        )

        #expect(
            result.contributionMarginPerUnit
            == 50
        )

        #expect(
            result.breakEvenProduction
            == 60000
        )

        #expect(
            result.breakEvenSalesRevenue
            == 7200000
        )

        #expect(
            result.breakEvenCapacityFraction
            == 0.5
        )

        #expect(
            result.expectedAnnualProfit
            == 1000000
        )

        #expect(
            result.expectedMarginOfSafetyUnits
            == 20000
        )

        #expect(
            result.expectedMarginOfSafetyFraction
            == 0.25
        )

        #expect(result.breakEvenIsWithinCapacity)
    }

    @Test("Detects break-even beyond capacity")
    func beyondCapacity() throws {
        let result = try engine.calculate(
            .init(
                annualFixedCost: 10_000,
                sellingPricePerUnit: 10,
                variableCostPerUnit: 9,
                expectedAnnualProduction: 5_000,
                maximumAnnualCapacity: 8_000
            )
        )

        #expect(
            result.breakEvenProduction
            == 10_000
        )

        #expect(
            !result.breakEvenIsWithinCapacity
        )
    }

    @Test("Rejects nonpositive contribution margin")
    func validation() {
        #expect(
            throws:
                BreakEvenProductionAnalysisError
                    .invalidContributionMargin
        ) {
            try engine.calculate(
                .init(
                    annualFixedCost: 3_000_000,
                    sellingPricePerUnit: 70,
                    variableCostPerUnit: 70,
                    expectedAnnualProduction: 80_000,
                    maximumAnnualCapacity: 120_000
                )
            )
        }
    }
}
