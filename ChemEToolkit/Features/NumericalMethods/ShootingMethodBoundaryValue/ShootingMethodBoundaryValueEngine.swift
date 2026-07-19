struct ShootingMethodBoundaryValueEngine: Sendable {
    private func integrate(_ slope: Double, _ input: ShootingMethodBoundaryValueInput) -> (Double,Int) {
        var x = input.initialX
        var y = input.initialY
        var v = slope
        var steps = 0
        while x < input.finalX {
            let h = min(input.stepSize,input.finalX-x)
            func acceleration(_ value: Double) -> Double { -input.coefficientK*value }
            let k1y = v
            let k1v = acceleration(y)
            let k2y = v+h*k1v/2
            let k2v = acceleration(y+h*k1y/2)
            let k3y = v+h*k2v/2
            let k3v = acceleration(y+h*k2y/2)
            let k4y = v+h*k3v
            let k4v = acceleration(y+h*k3y)
            y += h*(k1y+2*k2y+2*k3y+k4y)/6
            v += h*(k1v+2*k2v+2*k3v+k4v)/6
            x += h
            steps += 1
        }
        return (y,steps)
    }

    func calculate(_ input: ShootingMethodBoundaryValueInput) throws -> ShootingMethodBoundaryValueResult {
        let values = [input.coefficientK,input.initialX,input.finalX,input.initialY,input.targetFinalY,input.initialSlopeGuessOne,input.initialSlopeGuessTwo,input.stepSize,input.tolerance,input.maximumIterations]
        guard values.allSatisfy(\.isFinite) else { throw ShootingMethodBoundaryValueError.nonFiniteInput }
        let interval = input.finalX-input.initialX
        guard interval > 0 else { throw ShootingMethodBoundaryValueError.invalidInterval }
        guard input.stepSize > 0,input.stepSize <= interval else { throw ShootingMethodBoundaryValueError.invalidStep }
        guard input.tolerance > 0 else { throw ShootingMethodBoundaryValueError.invalidTolerance }
        let maxIterations = Int(input.maximumIterations)
        guard maxIterations > 0, Double(maxIterations) == input.maximumIterations else {
            throw ShootingMethodBoundaryValueError.invalidIterationLimit
        }

        var s1 = input.initialSlopeGuessOne
        var s2 = input.initialSlopeGuessTwo
        var sol1 = integrate(s1,input)
        var r1 = sol1.0-input.targetFinalY
        var sol2 = integrate(s2,input)
        var r2 = sol2.0-input.targetFinalY

        for iteration in 1...maxIterations {
            if abs(r2) < input.tolerance {
                return .init(
                    requiredInitialSlope: s2,
                    achievedFinalY: sol2.0,
                    boundaryResidual: r2,
                    iterationCount: Double(iteration),
                    integrationSteps: Double(sol2.1),
                    modelName: "Shooting method with secant slope updates",
                    limitationDescription: "Solves y'' + ky = 0 using RK4 integration."
                )
            }
            let denominator = r2-r1
            guard abs(denominator) > 1e-14 else { throw ShootingMethodBoundaryValueError.secantFailure }
            let next = s2-r2*(s2-s1)/denominator
            s1 = s2
            r1 = r2
            sol1 = sol2
            s2 = next
            sol2 = integrate(s2,input)
            r2 = sol2.0-input.targetFinalY
        }
        _ = sol1
        throw ShootingMethodBoundaryValueError.didNotConverge
    }
}
