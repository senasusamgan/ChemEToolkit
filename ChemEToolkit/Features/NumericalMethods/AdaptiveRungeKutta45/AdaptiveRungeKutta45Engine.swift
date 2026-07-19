import Foundation

struct AdaptiveRungeKutta45Engine: Sendable {
    private func f(_ x: Double, _ y: Double, _ input: AdaptiveRungeKutta45Input) -> Double {
        input.coefficientA*x + input.coefficientB*y
    }

    func calculate(_ input: AdaptiveRungeKutta45Input) throws -> AdaptiveRungeKutta45Result {
        let values = [input.coefficientA,input.coefficientB,input.initialX,input.finalX,input.initialY,input.initialStep,input.tolerance,input.maximumSteps]
        guard values.allSatisfy(\.isFinite) else { throw AdaptiveRungeKutta45Error.nonFiniteInput }
        guard input.finalX > input.initialX else { throw AdaptiveRungeKutta45Error.invalidInterval }
        guard input.initialStep > 0 else { throw AdaptiveRungeKutta45Error.invalidStep }
        guard input.tolerance > 0 else { throw AdaptiveRungeKutta45Error.invalidTolerance }
        let maxSteps = Int(input.maximumSteps)
        guard maxSteps > 0, Double(maxSteps) == input.maximumSteps else { throw AdaptiveRungeKutta45Error.invalidStepLimit }

        var x = input.initialX
        var y = input.initialY
        var h = input.initialStep
        var accepted = 0
        var rejected = 0
        var maxError = 0.0

        while x < input.finalX {
            if accepted + rejected >= maxSteps { throw AdaptiveRungeKutta45Error.didNotConverge }
            h = min(h, input.finalX - x)

            let k1 = f(x, y, input)
            let k2 = f(x+h/4, y+h*k1/4, input)
            let k3 = f(x+3*h/8, y+h*(3*k1/32+9*k2/32), input)
            let k4 = f(x+12*h/13, y+h*(1932*k1/2197-7200*k2/2197+7296*k3/2197), input)
            let k5 = f(x+h, y+h*(439*k1/216-8*k2+3680*k3/513-845*k4/4104), input)
            let k6 = f(x+h/2, y+h*(-8*k1/27+2*k2-3544*k3/2565+1859*k4/4104-11*k5/40), input)

            let y4 = y+h*(25*k1/216+1408*k3/2565+2197*k4/4104-k5/5)
            let y5 = y+h*(16*k1/135+6656*k3/12825+28561*k4/56430-9*k5/50+2*k6/55)
            let error = abs(y5-y4)
            maxError = max(maxError,error)

            if error <= input.tolerance {
                x += h
                y = y5
                accepted += 1
            } else {
                rejected += 1
            }

            let safeError = max(error,1e-30)
            let factor = 0.84*Foundation.pow(input.tolerance/safeError,0.25)
            h *= min(4,max(0.1,factor))
            guard h > 1e-14 else { throw AdaptiveRungeKutta45Error.stepUnderflow }
        }

        return .init(
            finalY: y,
            acceptedSteps: Double(accepted),
            rejectedSteps: Double(rejected),
            finalStepSize: h,
            maximumEstimatedError: maxError,
            modelName: "Adaptive embedded Runge–Kutta 4/5",
            limitationDescription: "Solves the educational first-order model dy/dx = ax + by."
        )
    }
}
