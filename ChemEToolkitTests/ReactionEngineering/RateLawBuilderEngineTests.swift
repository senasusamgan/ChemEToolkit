import Testing
@testable import ChemEToolkit

@Suite("Rate-Law Builder Engine")
struct RateLawBuilderEngineTests {
    private let engine = RateLawBuilderEngine()

    @Test("Builds an elementary-consistent law")
    func elementaryLaw() throws {
        let result = try engine.calculate(
            .init(
                stoichiometricCoefficientA: 1,
                stoichiometricCoefficientB: 2,
                reactionOrderA: 1,
                reactionOrderB: 2
            )
        )

        #expect(result.overallReactionOrder == 3)
        #expect(result.rateConstantConcentrationExponent == -2)
        #expect(result.isConsistentWithElementaryStep)
        #expect(result.powerLawExpression == "r = k C_A^1 C_B^2")
    }

    @Test("Flags empirical orders")
    func empiricalLaw() throws {
        let result = try engine.calculate(
            .init(
                stoichiometricCoefficientA: 1,
                stoichiometricCoefficientB: 1,
                reactionOrderA: 0.5,
                reactionOrderB: 1
            )
        )

        #expect(abs(result.overallReactionOrder - 1.5) < 1e-12)
        #expect(!result.isConsistentWithElementaryStep)
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(throws: RateLawBuilderError.nonPositiveStoichiometricCoefficient) {
            try engine.calculate(
                .init(
                    stoichiometricCoefficientA: 0,
                    stoichiometricCoefficientB: 1,
                    reactionOrderA: 1,
                    reactionOrderB: 1
                )
            )
        }

        #expect(throws: RateLawBuilderError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    stoichiometricCoefficientA: 1,
                    stoichiometricCoefficientB: 1,
                    reactionOrderA: .nan,
                    reactionOrderB: 1
                )
            )
        }
    }
}
