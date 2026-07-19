import Foundation

struct GaussNewtonNonlinearRegressionEngine: Sendable {
    func calculate(_ input: GaussNewtonNonlinearRegressionInput) throws -> GaussNewtonNonlinearRegressionResult {
        let values = [input.x1,input.y1,input.x2,input.y2,input.x3,input.y3,input.initialA,input.initialB,input.tolerance,input.maximumIterations]
        guard values.allSatisfy(\.isFinite) else { throw GaussNewtonNonlinearRegressionError.nonFiniteInput }
        guard input.y1 > 0,input.y2 > 0,input.y3 > 0 else { throw GaussNewtonNonlinearRegressionError.nonPositiveResponse }
        guard input.initialA > 0 else { throw GaussNewtonNonlinearRegressionError.invalidInitialA }
        guard input.tolerance > 0 else { throw GaussNewtonNonlinearRegressionError.invalidTolerance }
        let maxIterations = Int(input.maximumIterations)
        guard maxIterations > 0,Double(maxIterations) == input.maximumIterations else {
            throw GaussNewtonNonlinearRegressionError.invalidIterationLimit
        }

        let points = [(input.x1,input.y1),(input.x2,input.y2),(input.x3,input.y3)]
        var a = input.initialA
        var b = input.initialB

        for iteration in 1...maxIterations {
            var j11 = 0.0
            var j12 = 0.0
            var j22 = 0.0
            var g1 = 0.0
            var g2 = 0.0

            for point in points {
                let e = Foundation.exp(b*point.0)
                let prediction = a*e
                let residual = point.1-prediction
                let da = e
                let db = a*point.0*e
                j11 += da*da
                j12 += da*db
                j22 += db*db
                g1 += da*residual
                g2 += db*residual
            }

            let determinant = j11*j22-j12*j12
            guard abs(determinant) > 1e-14 else { throw GaussNewtonNonlinearRegressionError.singularNormalMatrix }
            let deltaA = (g1*j22-g2*j12)/determinant
            let deltaB = (j11*g2-j12*g1)/determinant
            a += deltaA
            b += deltaB
            guard a.isFinite,b.isFinite,a > 0 else { throw GaussNewtonNonlinearRegressionError.singularNormalMatrix }

            if max(abs(deltaA),abs(deltaB)) < input.tolerance {
                var sse = 0.0
                for point in points {
                    let residual = point.1-a*Foundation.exp(b*point.0)
                    sse += residual*residual
                }
                return .init(
                    parameterA: a,
                    parameterB: b,
                    sumSquaredError: sse,
                    rootMeanSquaredError: Foundation.sqrt(sse/3),
                    iterationCount: Double(iteration),
                    modelName: "Gauss–Newton fit for y = a·exp(bx)",
                    limitationDescription: "Uses three observations and an undamped two-parameter update."
                )
            }
        }
        throw GaussNewtonNonlinearRegressionError.didNotConverge
    }
}
