import Foundation

struct InverseLaplaceTransformHelperEngine:
    Sendable {

    func calculate(
        _ input: InverseLaplaceTransformHelperInput
    ) throws -> InverseLaplaceTransformHelperResult {

        let values = [
            input.amplitude,
            input.parameter,
            input.evaluationTime
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw InverseLaplaceTransformHelperError.nonFiniteInput
        }

        guard input.evaluationTime >= 0 else {
            throw InverseLaplaceTransformHelperError.negativeEvaluationTime
        }

        let transform: String
        let timeFunction: String
        let value: Double
        let initial: Double
        let final: Double?

        switch input.form {
        case .constantOverS:
            transform = "\(input.amplitude) / s"
            timeFunction = "\(input.amplitude)"
            value = input.amplitude
            initial = input.amplitude
            final = input.amplitude

        case .constantOverSSquared:
            transform = "\(input.amplitude) / s²"
            timeFunction = "\(input.amplitude)·t"
            value = input.amplitude * input.evaluationTime
            initial = 0
            final = nil

        case .shiftedPole:
            guard input.parameter > 0 else {
                throw InverseLaplaceTransformHelperError.nonPositiveParameter
            }
            transform = "\(input.amplitude) / (s + \(input.parameter))"
            timeFunction = "\(input.amplitude)·e^(−\(input.parameter)t)"
            value = input.amplitude * exp(-input.parameter * input.evaluationTime)
            initial = input.amplitude
            final = 0

        case .cosineForm:
            guard input.parameter > 0 else {
                throw InverseLaplaceTransformHelperError.nonPositiveParameter
            }
            transform = "\(input.amplitude)·s / (s² + \(input.parameter * input.parameter))"
            timeFunction = "\(input.amplitude)·cos(\(input.parameter)t)"
            value = input.amplitude * cos(input.parameter * input.evaluationTime)
            initial = input.amplitude
            final = nil

        case .sineForm:
            guard input.parameter > 0 else {
                throw InverseLaplaceTransformHelperError.nonPositiveParameter
            }
            transform = "\(input.amplitude * input.parameter) / (s² + \(input.parameter * input.parameter))"
            timeFunction = "\(input.amplitude)·sin(\(input.parameter)t)"
            value = input.amplitude * sin(input.parameter * input.evaluationTime)
            initial = 0
            final = nil

        case .firstOrderStep:
            guard input.parameter > 0 else {
                throw InverseLaplaceTransformHelperError.nonPositiveParameter
            }
            transform = "\(input.amplitude) / [s(\(input.parameter)s + 1)]"
            timeFunction = "\(input.amplitude)·[1 − e^(−t/\(input.parameter))]"
            value = input.amplitude * (1 - exp(-input.evaluationTime / input.parameter))
            initial = 0
            final = input.amplitude
        }

        guard value.isFinite, initial.isFinite else {
            throw InverseLaplaceTransformHelperError.numericalFailure
        }

        return .init(
            transformExpression: transform,
            timeDomainExpression: timeFunction,
            evaluatedTimeResponse: value,
            initialValue: initial,
            finalValue: final,
            modelName: "Common inverse-Laplace transform pairs",
            limitationDescription: "Supports six standard forms and numerical evaluation for t ≥ 0. Partial-fraction decomposition of arbitrary rational expressions is outside this helper."
        )
    }
}
