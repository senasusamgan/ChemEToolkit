import Testing
@testable import ChemEToolkit

@Suite("Conversion Yield Selectivity Engine")
struct ReactionPerformanceBalanceEngineTests {
    private let engine =
        ReactionPerformanceBalanceEngine()

    @Test("Calculates conversion yield and selectivity")
    func performance() throws {
        let result = try engine.calculate(
            .init(
                reactantFeedAmount: 100,
                reactantOutletAmount: 20,
                desiredProductAmount: 60,
                undesiredProductAmount: 20
            )
        )

        #expect(result.reactantConsumedAmount == 80)
        #expect(result.conversionFraction == 0.80)
        #expect(result.desiredYieldOnFeed == 0.60)
        #expect(result.desiredYieldOnReactedBasis == 0.75)
        #expect(result.desiredToUndesiredSelectivity == 3)
        #expect(
            result.desiredProductDistributionFraction
            == 0.75
        )
    }

    @Test("No undesired product gives infinite selectivity")
    func perfectSelectivity() throws {
        let result = try engine.calculate(
            .init(
                reactantFeedAmount: 100,
                reactantOutletAmount: 50,
                desiredProductAmount: 50,
                undesiredProductAmount: 0
            )
        )

        #expect(
            result.desiredToUndesiredSelectivity
            == .infinity
        )
    }

    @Test("Rejects products above reactant consumption")
    func validation() {
        #expect(
            throws:
                ReactionPerformanceBalanceError
                    .productExceedsReactantConsumption
        ) {
            try engine.calculate(
                .init(
                    reactantFeedAmount: 100,
                    reactantOutletAmount: 50,
                    desiredProductAmount: 40,
                    undesiredProductAmount: 20
                )
            )
        }
    }
}
