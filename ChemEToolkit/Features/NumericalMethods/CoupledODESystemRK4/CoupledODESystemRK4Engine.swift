import Foundation

struct CoupledODESystemRK4Engine: Sendable {
    private func derivative(_ x: Double, _ y: Double, _ input: CoupledODESystemRK4Input) -> (Double,Double) {
        (input.a11*x+input.a12*y, input.a21*x+input.a22*y)
    }

    func calculate(_ input: CoupledODESystemRK4Input) throws -> CoupledODESystemRK4Result {
        let values = [input.a11,input.a12,input.a21,input.a22,input.initialX,input.initialY,input.finalTime,input.stepSize]
        guard values.allSatisfy(\.isFinite) else { throw CoupledODESystemRK4Error.nonFiniteInput }
        guard input.finalTime > 0 else { throw CoupledODESystemRK4Error.nonPositiveFinalTime }
        guard input.stepSize > 0, input.stepSize <= input.finalTime else { throw CoupledODESystemRK4Error.invalidStep }

        var t = 0.0
        var x = input.initialX
        var y = input.initialY
        var steps = 0

        while t < input.finalTime {
            let h = min(input.stepSize,input.finalTime-t)
            let k1 = derivative(x,y,input)
            let k2 = derivative(x+h*k1.0/2,y+h*k1.1/2,input)
            let k3 = derivative(x+h*k2.0/2,y+h*k2.1/2,input)
            let k4 = derivative(x+h*k3.0,y+h*k3.1,input)
            x += h*(k1.0+2*k2.0+2*k3.0+k4.0)/6
            y += h*(k1.1+2*k2.1+2*k3.1+k4.1)/6
            t += h
            steps += 1
            guard x.isFinite,y.isFinite else { throw CoupledODESystemRK4Error.numericalFailure }
        }

        return .init(
            finalX: x,
            finalY: y,
            finalMagnitude: Foundation.sqrt(x*x+y*y),
            stepCount: Double(steps),
            finalTime: t,
            modelName: "Classical RK4 for a 2×2 linear ODE system",
            limitationDescription: "Solves x' = a11x + a12y and y' = a21x + a22y using a fixed step."
        )
    }
}
