import Testing
@testable import ChemEToolkit

@Suite("Block-Diagram Algebra Engine")
struct BlockDiagramAlgebraEngineTests {
    private let engine = BlockDiagramAlgebraEngine()

    @Test("Reduces series parallel and feedback blocks")
    func reductions() throws {
        let result = try engine.calculate(
            .init(
                firstForwardBlockGain: 2,
                secondForwardBlockGain: 3,
                feedbackBlockGain: 0.1
            )
        )

        #expect(result.seriesGain == 6)
        #expect(result.parallelGain == 5)
        #expect(abs(result.loopGain - 0.6) < 1e-12)
        #expect(abs(result.negativeFeedbackGain! - 3.75) < 1e-12)
        #expect(abs(result.positiveFeedbackGain! - 15) < 1e-12)
        #expect(abs(result.negativeFeedbackSensitivity! - 0.625) < 1e-12)
    }

    @Test("Reports singular feedback configurations")
    func singularity() throws {
        let positiveSingular = try engine.calculate(
            .init(
                firstForwardBlockGain: 2,
                secondForwardBlockGain: 3,
                feedbackBlockGain: 1.0 / 6.0
            )
        )

        #expect(positiveSingular.positiveFeedbackGain == nil)
        #expect(positiveSingular.negativeFeedbackGain != nil)

        let negativeSingular = try engine.calculate(
            .init(
                firstForwardBlockGain: 2,
                secondForwardBlockGain: 3,
                feedbackBlockGain: -1.0 / 6.0
            )
        )

        #expect(negativeSingular.negativeFeedbackGain == nil)
        #expect(negativeSingular.positiveFeedbackGain != nil)
    }

    @Test("Rejects nonfinite inputs")
    func validation() {
        #expect(throws: BlockDiagramAlgebraError.nonFiniteInput) {
            try engine.calculate(
                .init(
                    firstForwardBlockGain: .infinity,
                    secondForwardBlockGain: 3,
                    feedbackBlockGain: 0.1
                )
            )
        }
    }
}
