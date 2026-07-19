struct GoldenSectionOptimizationEngine: Sendable {
    private func objective(_ x: Double, _ input: GoldenSectionOptimizationInput) -> Double {
        input.quadraticA*x*x + input.quadraticB*x + input.quadraticC
    }

    func calculate(_ input: GoldenSectionOptimizationInput) throws -> GoldenSectionOptimizationResult {
        let values = [input.quadraticA,input.quadraticB,input.quadraticC,input.lowerBound,input.upperBound,input.tolerance,input.maximumIterations]
        guard values.allSatisfy(\.isFinite) else { throw GoldenSectionOptimizationError.nonFiniteInput }
        guard input.quadraticA > 0 else { throw GoldenSectionOptimizationError.nonConvexQuadratic }
        guard input.upperBound > input.lowerBound else { throw GoldenSectionOptimizationError.invalidBounds }
        guard input.tolerance > 0 else { throw GoldenSectionOptimizationError.invalidTolerance }
        let maxIterations = Int(input.maximumIterations)
        guard maxIterations > 0,Double(maxIterations) == input.maximumIterations else {
            throw GoldenSectionOptimizationError.invalidIterationLimit
        }

        let ratio = (5.0.squareRoot()-1)/2
        var lower = input.lowerBound
        var upper = input.upperBound
        var x1 = upper-ratio*(upper-lower)
        var x2 = lower+ratio*(upper-lower)
        var f1 = objective(x1,input)
        var f2 = objective(x2,input)

        for iteration in 1...maxIterations {
            if upper-lower < input.tolerance {
                let x = (lower+upper)/2
                return .init(
                    minimizingX: x,
                    minimumValue: objective(x,input),
                    finalIntervalWidth: upper-lower,
                    iterationCount: Double(iteration),
                    analyticalStationaryPoint: -input.quadraticB/(2*input.quadraticA),
                    modelName: "Golden-section bounded minimization",
                    limitationDescription: "Minimizes the convex quadratic ax² + bx + c on the entered interval."
                )
            }

            if f1 > f2 {
                lower = x1
                x1 = x2
                f1 = f2
                x2 = lower+ratio*(upper-lower)
                f2 = objective(x2,input)
            } else {
                upper = x2
                x2 = x1
                f2 = f1
                x1 = upper-ratio*(upper-lower)
                f1 = objective(x1,input)
            }
        }
        throw GoldenSectionOptimizationError.didNotConverge
    }
}
