import Testing
@testable import ChemEToolkit

@Suite("Laplace Transform Helper Engine")
struct LaplaceTransformHelperEngineTests {
    private let engine = LaplaceTransformHelperEngine()

    @Test("Evaluates common transform pairs")
    func transformPairs() throws {
        let exponential = try engine.calculate(
            .init(function: .exponential, amplitude: 2, parameter: 0.5, evaluationS: 2)
        )
        #expect(abs(exponential.evaluatedTransform - 4.0 / 3.0) < 1e-12)

        let sine = try engine.calculate(
            .init(function: .sine, amplitude: 3, parameter: 2, evaluationS: 1)
        )
        #expect(abs(sine.evaluatedTransform - 1.2) < 1e-12)
    }

    @Test("Ramp transform follows inverse-square law")
    func ramp() throws {
        let result = try engine.calculate(
            .init(function: .ramp, amplitude: 8, parameter: 0, evaluationS: 2)
        )
        #expect(result.evaluatedTransform == 2)
    }

    @Test("Rejects invalid domains")
    func validation() {
        #expect(throws: LaplaceTransformHelperError.outsideConvergenceRegion) {
            try engine.calculate(
                .init(function: .exponential, amplitude: 2, parameter: 3, evaluationS: 2)
            )
        }

        #expect(throws: LaplaceTransformHelperError.invalidFrequency) {
            try engine.calculate(
                .init(function: .sine, amplitude: 2, parameter: 0, evaluationS: 2)
            )
        }
    }
}
