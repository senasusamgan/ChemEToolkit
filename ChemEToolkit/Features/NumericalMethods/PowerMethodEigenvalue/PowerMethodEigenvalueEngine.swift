import Foundation

struct PowerMethodEigenvalueEngine: Sendable {
    func calculate(_ input: PowerMethodEigenvalueInput) throws -> PowerMethodEigenvalueResult {
        let values = [input.a11,input.a12,input.a21,input.a22,input.initialX,input.initialY,input.tolerance,input.maximumIterations]
        guard values.allSatisfy(\.isFinite) else { throw PowerMethodEigenvalueError.nonFiniteInput }
        let norm0 = Foundation.sqrt(input.initialX*input.initialX + input.initialY*input.initialY)
        guard norm0 > 0 else { throw PowerMethodEigenvalueError.zeroInitialVector }
        guard input.tolerance > 0 else { throw PowerMethodEigenvalueError.invalidTolerance }
        let maxIterations = Int(input.maximumIterations)
        guard maxIterations > 0, Double(maxIterations) == input.maximumIterations else {
            throw PowerMethodEigenvalueError.invalidIterationLimit
        }

        var x = input.initialX / norm0
        var y = input.initialY / norm0
        var lambda = 0.0

        for iteration in 1...maxIterations {
            let vx = input.a11*x + input.a12*y
            let vy = input.a21*x + input.a22*y
            let norm = Foundation.sqrt(vx*vx + vy*vy)
            guard norm > 0 else { throw PowerMethodEigenvalueError.singularIteration }
            let nx = vx / norm
            let ny = vy / norm
            let ax = input.a11*nx + input.a12*ny
            let ay = input.a21*nx + input.a22*ny
            let nextLambda = nx*ax + ny*ay
            let change = max(abs(nx-x), abs(ny-y), abs(nextLambda-lambda))
            x = nx
            y = ny
            lambda = nextLambda
            if change < input.tolerance {
                let rx = ax - lambda*x
                let ry = ay - lambda*y
                return .init(
                    dominantEigenvalue: lambda,
                    eigenvectorX: x,
                    eigenvectorY: y,
                    residualNorm: Foundation.sqrt(rx*rx + ry*ry),
                    iterationCount: Double(iteration),
                    modelName: "Normalized power iteration",
                    limitationDescription: "Best suited to matrices with one dominant eigenvalue magnitude."
                )
            }
        }
        throw PowerMethodEigenvalueError.didNotConverge
    }
}
