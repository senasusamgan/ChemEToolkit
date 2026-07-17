import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Lifecycle Cost Analysis Engine")
struct LifecycleCostAnalysisEngineTests {
    private let engine =
        LifecycleCostAnalysisEngine()

    @Test("Calculates discounted lifecycle cost")
    func lifecycleCost() throws {
        let result = try engine.calculate(
            .init(
                initialCapitalCost: 2_000_000,
                annualOperatingCost: 300_000,
                annualMaintenanceCost: 50_000,
                periodicReplacementCost: 400_000,
                replacementIntervalYears: 5,
                terminalSalvageValue: 200_000,
                projectLifeYears: 15,
                discountRateFraction: 0.08
            )
        )

        let annuityFactor =
            (
                1
                - Foundation.pow(1.08, Double(-15))
            )
            / 0.08

        let replacementPV =
            400_000 / Foundation.pow(1.08, Double(5))
            + 400_000 / Foundation.pow(1.08, Double(10))

        let salvagePV =
            200_000 / Foundation.pow(1.08, Double(15))

        let total =
            2_000_000
            + 300_000 * annuityFactor
            + 50_000 * annuityFactor
            + replacementPV
            - salvagePV

        #expect(result.replacementCount == 2)

        #expect(
            abs(
                result.presentValueOfReplacementCost
                - replacementPV
            ) < 1e-8
        )

        #expect(
            abs(
                result.totalLifecycleCost
                - total
            ) < 1e-8
        )

        #expect(
            result.dominantCostCategory
            == "Operating"
        )
    }

    @Test("Zero discount uses undiscounted annual costs")
    func zeroDiscount() throws {
        let result = try engine.calculate(
            .init(
                initialCapitalCost: 100,
                annualOperatingCost: 10,
                annualMaintenanceCost: 5,
                periodicReplacementCost: 20,
                replacementIntervalYears: 2,
                terminalSalvageValue: 10,
                projectLifeYears: 4,
                discountRateFraction: 0
            )
        )

        #expect(result.replacementCount == 1)
        #expect(result.totalLifecycleCost == 170)
        #expect(result.equivalentAnnualCost == 42.5)
    }

    @Test("Rejects noninteger replacement interval")
    func validation() {
        #expect(
            throws:
                LifecycleCostAnalysisError
                    .invalidReplacementInterval
        ) {
            try engine.calculate(
                .init(
                    initialCapitalCost: 100,
                    annualOperatingCost: 10,
                    annualMaintenanceCost: 5,
                    periodicReplacementCost: 20,
                    replacementIntervalYears: 2.5,
                    terminalSalvageValue: 10,
                    projectLifeYears: 4,
                    discountRateFraction: 0
                )
            )
        }
    }
}
