import Foundation

struct LaplaceTransformHelperEngine:
    Sendable {

    func calculate(
        _ input: LaplaceTransformHelperInput
    ) throws -> LaplaceTransformHelperResult {

        let values = [
            input.amplitude,
            input.parameter,
            input.evaluationS
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw LaplaceTransformHelperError.nonFiniteInput
        }

        guard input.evaluationS > 0 else {
            throw LaplaceTransformHelperError.nonPositiveEvaluationS
        }

        let timeExpression: String
        let transformExpression: String
        let value: Double
        let convergence: String

        switch input.function {
        case .constant:
            timeExpression = "\(input.amplitude)"
            transformExpression = "\(input.amplitude) / s"
            value = input.amplitude / input.evaluationS
            convergence = "Converges for Re(s) > 0."

        case .ramp:
            timeExpression = "\(input.amplitude)·t"
            transformExpression = "\(input.amplitude) / s²"
            value = input.amplitude / (input.evaluationS * input.evaluationS)
            convergence = "Converges for Re(s) > 0."

        case .exponential:
            guard input.evaluationS > input.parameter else {
                throw LaplaceTransformHelperError.outsideConvergenceRegion
            }
            timeExpression = "\(input.amplitude)·e^(\(input.parameter)t)"
            transformExpression = "\(input.amplitude) / (s − \(input.parameter))"
            value = input.amplitude / (input.evaluationS - input.parameter)
            convergence = "Converges for Re(s) > \(input.parameter)."

        case .sine:
            guard input.parameter > 0 else {
                throw LaplaceTransformHelperError.invalidFrequency
            }
            timeExpression = "\(input.amplitude)·sin(\(input.parameter)t)"
            transformExpression = "\(input.amplitude * input.parameter) / (s² + \(input.parameter * input.parameter))"
            value = input.amplitude * input.parameter
                / (input.evaluationS * input.evaluationS + input.parameter * input.parameter)
            convergence = "Converges for Re(s) > 0."

        case .cosine:
            guard input.parameter > 0 else {
                throw LaplaceTransformHelperError.invalidFrequency
            }
            timeExpression = "\(input.amplitude)·cos(\(input.parameter)t)"
            transformExpression = "\(input.amplitude)·s / (s² + \(input.parameter * input.parameter))"
            value = input.amplitude * input.evaluationS
                / (input.evaluationS * input.evaluationS + input.parameter * input.parameter)
            convergence = "Converges for Re(s) > 0."
        }

        guard value.isFinite else {
            throw LaplaceTransformHelperError.numericalFailure
        }

        return .init(
            timeDomainExpression: timeExpression,
            transformExpression: transformExpression,
            evaluatedTransform: value,
            convergenceDescription: convergence,
            modelName: "Common one-sided Laplace-transform pairs",
            limitationDescription: "Supports constants, ramps, exponentials, sine and cosine functions evaluated at a positive real s. It is not a symbolic algebra system."
        )
    }
}
