import Testing
@testable import ChemEToolkit

@Suite("Rate Constant Calculation Engine")
struct RateConstantCalculationEngineTests {
    private let engine = RateConstantCalculationEngine()

    @Test("Calculates a third-order rate constant")
    func calculatesConstant() throws {
        let result = try engine.calculate(
            .init(
                measuredReactionRate: 9,
                concentrationA: 2,
                concentrationB: 3,
                reactionOrderA: 1,
                reactionOrderB: 2
            )
        )

        #expect(abs(result.rateConstant - 0.5) < 1e-12)
        #expect(result.overallReactionOrder == 3)
        #expect(abs(result.concentrationProduct - 18) < 1e-12)
        #expect(abs(result.observedConstantWithBFixed - 4.5) < 1e-12)
        #expect(abs(result.observedConstantWithAFixed - 1) < 1e-12)
    }

    @Test("Supports zero-order concentration dependence")
    func zeroOrder() throws {
        let result = try engine.calculate(
            .init(
                measuredReactionRate: 4,
                concentrationA: 10,
                concentrationB: 20,
                reactionOrderA: 0,
                reactionOrderB: 0
            )
        )

        #expect(result.rateConstant == 4)
        #expect(result.overallReactionOrder == 0)
        #expect(result.concentrationProduct == 1)
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(throws: RateConstantCalculationError.nonPositiveRate) {
            try engine.calculate(
                .init(
                    measuredReactionRate: 0,
                    concentrationA: 2,
                    concentrationB: 3,
                    reactionOrderA: 1,
                    reactionOrderB: 2
                )
            )
        }

        #expect(throws: RateConstantCalculationError.nonPositiveConcentration) {
            try engine.calculate(
                .init(
                    measuredReactionRate: 9,
                    concentrationA: -1,
                    concentrationB: 3,
                    reactionOrderA: 1,
                    reactionOrderB: 2
                )
            )
        }

        #expect(throws: RateConstantCalculationError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    measuredReactionRate: .nan,
                    concentrationA: 2,
                    concentrationB: 3,
                    reactionOrderA: 1,
                    reactionOrderB: 2
                )
            )
        }
    }
}
