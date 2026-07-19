import Foundation
struct LevenbergMarquardtRegressionEngine {
    func solve(_ input: LevenbergMarquardtRegressionInput) throws -> LevenbergMarquardtRegressionResult {
        try validate(input)
        func predict(_ x: Double, _ p: [Double]) -> Double {
            switch input.model { case .exponential: return p[0] * exp(p[1] * x); case .saturation: return p[0] * x / (p[1] + x) }
        }
        func predictions(_ p: [Double]) -> [Double] { input.xValues.map { predict($0, p) } }
        func sse(_ p: [Double]) -> Double { zip(input.yValues, predictions(p)).reduce(0.0) { let r = $1.0 - $1.1; return $0 + r * r } }
        var p = input.initialParameters, lambda = input.initialDamping, currentSSE = sse(p)
        for iteration in 1...input.maximumIterations {
            let predicted = predictions(p), residuals = zip(input.yValues, predicted).map { $0.0 - $0.1 }
            var j = Array(repeating: [0.0, 0.0], count: input.xValues.count)
            for column in 0..<2 {
                let h = sqrt(Double.ulpOfOne) * max(1, abs(p[column]))
                var shifted = p; shifted[column] += h
                let shiftedPredictions = predictions(shifted)
                for row in j.indices { j[row][column] = (shiftedPredictions[row] - predicted[row]) / h }
            }
            var normal = [[0.0, 0.0], [0.0, 0.0]], gradient = [0.0, 0.0]
            for row in j.indices {
                for c in 0..<2 {
                    gradient[c] += j[row][c] * residuals[row]
                    for d in 0..<2 { normal[c][d] += j[row][c] * j[row][d] }
                }
            }
            if sqrt(gradient[0] * gradient[0] + gradient[1] * gradient[1]) <= input.tolerance {
                return .init(parameters: p, predictions: predicted, sumSquaredErrors: currentSSE, iterations: iteration)
            }
            normal[0][0] += lambda; normal[1][1] += lambda
            let det = normal[0][0] * normal[1][1] - normal[0][1] * normal[1][0]
            guard abs(det) > 1e-24 else { throw LevenbergMarquardtRegressionError.singularNormalMatrix }
            let delta = [(gradient[0] * normal[1][1] - normal[0][1] * gradient[1]) / det,
                         (normal[0][0] * gradient[1] - gradient[0] * normal[1][0]) / det]
            let candidate = zip(p, delta).map { $0.0 + $0.1 }
            if input.model == .saturation && candidate[1] <= 0 { lambda *= 10; continue }
            let candidateSSE = sse(candidate)
            if candidateSSE <= currentSSE {
                p = candidate; currentSSE = candidateSSE; lambda = max(lambda / 3, 1e-15)
                if sqrt(delta[0] * delta[0] + delta[1] * delta[1]) <= input.tolerance {
                    return .init(parameters: p, predictions: predictions(p), sumSquaredErrors: currentSSE, iterations: iteration)
                }
            } else { lambda *= 10 }
        }
        throw LevenbergMarquardtRegressionError.didNotConverge
    }
    private func validate(_ input: LevenbergMarquardtRegressionInput) throws {
        guard input.xValues.count >= 3, input.yValues.count == input.xValues.count else { throw LevenbergMarquardtRegressionError.invalidData }
        if input.model == .saturation, input.xValues.contains(where: { $0 < 0 }) { throw LevenbergMarquardtRegressionError.invalidData }
        guard (input.xValues + input.yValues + input.initialParameters + [input.initialDamping, input.tolerance]).allSatisfy(\.isFinite) else { throw LevenbergMarquardtRegressionError.nonFiniteInput }
        guard input.initialParameters.count == 2, input.model != .saturation || input.initialParameters[1] > 0 else { throw LevenbergMarquardtRegressionError.invalidInitialParameters }
        guard input.initialDamping > 0, input.tolerance > 0, input.maximumIterations > 0 else { throw LevenbergMarquardtRegressionError.invalidControls }
    }
}
