import Testing
@testable import ChemEToolkit

@Suite("Reaction Order Determination Engine")
struct ReactionOrderDeterminationEngineTests {
    private let engine = ReactionOrderDeterminationEngine()

    @Test("Determines second-order kinetics")
    func secondOrder() throws {
        let result = try engine.calculate(
            .init(
                concentrationExperimentOne: 1,
                rateExperimentOne: 0.5,
                concentrationExperimentTwo: 2,
                rateExperimentTwo: 2
            )
        )

        #expect(abs(result.reactionOrder - 2) < 1e-12)
        #expect(result.classification == .secondOrder)
        #expect(abs(result.averageRateConstant - 0.5) < 1e-12)
    }

    @Test("Determines zero-order kinetics")
    func zeroOrder() throws {
        let result = try engine.calculate(
            .init(
                concentrationExperimentOne: 1,
                rateExperimentOne: 3,
                concentrationExperimentTwo: 2,
                rateExperimentTwo: 3
            )
        )

        #expect(abs(result.reactionOrder) < 1e-12)
        #expect(result.classification == .zeroOrder)
    }

    @Test("Rejects invalid data")
    func validation() {
        #expect(throws: ReactionOrderDeterminationError.equalConcentrations) {
            try engine.calculate(
                .init(
                    concentrationExperimentOne: 1,
                    rateExperimentOne: 0.5,
                    concentrationExperimentTwo: 1,
                    rateExperimentTwo: 2
                )
            )
        }

        #expect(throws: ReactionOrderDeterminationError.nonPositiveConcentrationOrRate) {
            try engine.calculate(
                .init(
                    concentrationExperimentOne: 1,
                    rateExperimentOne: 0,
                    concentrationExperimentTwo: 2,
                    rateExperimentTwo: 2
                )
            )
        }

        #expect(throws: ReactionOrderDeterminationError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    concentrationExperimentOne: .nan,
                    rateExperimentOne: 0.5,
                    concentrationExperimentTwo: 2,
                    rateExperimentTwo: 2
                )
            )
        }
    }
}
