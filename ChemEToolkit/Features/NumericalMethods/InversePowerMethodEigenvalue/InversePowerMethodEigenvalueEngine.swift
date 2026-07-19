import Foundation

struct InversePowerMethodEigenvalueEngine: Sendable {
    func calculate(_ input: InversePowerMethodEigenvalueInput) throws -> InversePowerMethodEigenvalueResult {
        let values = [input.a11,input.a12,input.a21,input.a22,input.shift,input.initialX,input.initialY,input.tolerance,input.maximumIterations]
        guard values.allSatisfy(\.isFinite) else { throw InversePowerMethodEigenvalueError.nonFiniteInput }
        let norm0 = Foundation.sqrt(input.initialX*input.initialX + input.initialY*input.initialY)
        guard norm0 > 0 else { throw InversePowerMethodEigenvalueError.zeroInitialVector }
        guard input.tolerance > 0 else { throw InversePowerMethodEigenvalueError.invalidTolerance }
        let maxIterations = Int(input.maximumIterations)
        guard maxIterations > 0, Double(maxIterations) == input.maximumIterations else {
            throw InversePowerMethodEigenvalueError.invalidIterationLimit
        }

        let b11 = input.a11 - input.shift
        let b22 = input.a22 - input.shift
        let determinant = b11*b22 - input.a12*input.a21
        guard abs(determinant) > 1e-14 else { throw InversePowerMethodEigenvalueError.singularShiftedMatrix }

        var x = input.initialX / norm0
        var y = input.initialY / norm0
        var lambda = input.shift

        for iteration in 1...maxIterations {
            let sx = (b22*x - input.a12*y) / determinant
            let sy = (-input.a21*x + b11*y) / determinant
            let norm = Foundation.sqrt(sx*sx + sy*sy)
            guard norm > 0 else { throw InversePowerMethodEigenvalueError.singularShiftedMatrix }
            let nx = sx / norm
            let ny = sy / norm
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
                    nearestEigenvalue: lambda,
                    eigenvectorX: x,
                    eigenvectorY: y,
                    residualNorm: Foundation.sqrt(rx*rx + ry*ry),
                    iterationCount: Double(iteration),
                    modelName: "Shifted inverse power iteration",
                    limitationDescription: "Returns the eigenvalue nearest the selected shift when the shifted matrix is nonsingular."
                )
            }
        }
        throw InversePowerMethodEigenvalueError.didNotConverge
    }
}
