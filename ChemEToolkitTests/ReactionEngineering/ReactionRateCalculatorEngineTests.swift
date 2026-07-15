import Testing
@testable import ChemEToolkit

@Suite("Reaction Rate Calculator Engine")
struct ReactionRateCalculatorEngineTests {
    private let engine = ReactionRateCalculatorEngine()

    @Test("Calculates power-law and species rates")
    func calculatesRates() throws {
        let result = try engine.calculate(
            .init(
                rateConstant: 0.5,
                concentrationA: 2,
                concentrationB: 3,
                reactionOrderA: 1,
                reactionOrderB: 2,
                stoichiometricCoefficientA: 1,
                stoichiometricCoefficientB: 2
            )
        )

        #expect(result.overallReactionOrder == 3)
        #expect(abs(result.rateOfReaction - 9) < 1e-12)
        #expect(abs(result.disappearanceRateA - 9) < 1e-12)
        #expect(abs(result.disappearanceRateB - 18) < 1e-12)
    }

    @Test("Supports zero and negative empirical orders")
    func empiricalOrders() throws {
        let result = try engine.calculate(
            .init(
                rateConstant: 2,
                concentrationA: 4,
                concentrationB: 2,
                reactionOrderA: 0,
                reactionOrderB: -1,
                stoichiometricCoefficientA: 1,
                stoichiometricCoefficientB: 1
            )
        )

        #expect(result.overallReactionOrder == -1)
        #expect(abs(result.rateOfReaction - 1) < 1e-12)
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(throws: ReactionRateCalculatorError.nonPositiveRateConstant) {
            try engine.calculate(
                .init(
                    rateConstant: 0,
                    concentrationA: 2,
                    concentrationB: 3,
                    reactionOrderA: 1,
                    reactionOrderB: 2,
                    stoichiometricCoefficientA: 1,
                    stoichiometricCoefficientB: 2
                )
            )
        }

        #expect(throws: ReactionRateCalculatorError.nonPositiveConcentration) {
            try engine.calculate(
                .init(
                    rateConstant: 0.5,
                    concentrationA: 0,
                    concentrationB: 3,
                    reactionOrderA: 1,
                    reactionOrderB: 2,
                    stoichiometricCoefficientA: 1,
                    stoichiometricCoefficientB: 2
                )
            )
        }

        #expect(throws: ReactionRateCalculatorError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    rateConstant: .nan,
                    concentrationA: 2,
                    concentrationB: 3,
                    reactionOrderA: 1,
                    reactionOrderB: 2,
                    stoichiometricCoefficientA: 1,
                    stoichiometricCoefficientB: 2
                )
            )
        }
    }
}
