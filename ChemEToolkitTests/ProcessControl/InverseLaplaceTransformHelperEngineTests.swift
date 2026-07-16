import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Inverse Laplace Transform Helper Engine")
struct InverseLaplaceTransformHelperEngineTests {
    private let engine = InverseLaplaceTransformHelperEngine()

    @Test("Evaluates first-order step response")
    func firstOrderStep() throws {
        let result = try engine.calculate(
            .init(form: .firstOrderStep, amplitude: 10, parameter: 4, evaluationTime: 6)
        )

        #expect(
            abs(
                result.evaluatedTimeResponse
                - 10 * (1 - Foundation.exp(-1.5))
            ) < 1e-12
        )
        #expect(result.initialValue == 0)
        #expect(result.finalValue == 10)
    }

    @Test("Evaluates shifted pole and oscillatory forms")
    func otherForms() throws {
        let pole = try engine.calculate(
            .init(form: .shiftedPole, amplitude: 2, parameter: 0.5, evaluationTime: 2)
        )
        #expect(abs(pole.evaluatedTimeResponse - 2 * Foundation.exp(-1)) < 1e-12)

        let cosine = try engine.calculate(
            .init(form: .cosineForm, amplitude: 3, parameter: 2, evaluationTime: 0)
        )
        #expect(cosine.evaluatedTimeResponse == 3)
    }

    @Test("Rejects invalid time and parameters")
    func validation() {
        #expect(throws: InverseLaplaceTransformHelperError.negativeEvaluationTime) {
            try engine.calculate(
                .init(form: .constantOverS, amplitude: 2, parameter: 0, evaluationTime: -1)
            )
        }

        #expect(throws: InverseLaplaceTransformHelperError.nonPositiveParameter) {
            try engine.calculate(
                .init(form: .firstOrderStep, amplitude: 2, parameter: 0, evaluationTime: 1)
            )
        }
    }
}
