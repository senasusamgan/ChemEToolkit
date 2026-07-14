import Foundation

enum ODESolverMethod:
    String,
    CaseIterable,
    Identifiable,
    Codable,
    Hashable {

    case euler
    case heun
    case rungeKuttaFourth

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .euler:
            return "Euler Method"

        case .heun:
            return "Heun Method"

        case .rungeKuttaFourth:
            return "Fourth-Order Runge–Kutta"
        }
    }

    var pickerTitle: String {
        switch self {
        case .euler:
            return "Euler"

        case .heun:
            return "Heun"

        case .rungeKuttaFourth:
            return "RK4"
        }
    }

    var formula: String {
        switch self {
        case .euler:
            return "yₙ₊₁ = yₙ + h f(xₙ, yₙ)"

        case .heun:
            return "yₙ₊₁ = yₙ + h(k₁ + k₂) / 2"

        case .rungeKuttaFourth:
            return "yₙ₊₁ = yₙ + h(k₁ + 2k₂ + 2k₃ + k₄) / 6"
        }
    }

    var explanation: String {
        switch self {
        case .euler:
            return """
            A simple first-order method using the slope at the beginning of each step.
            """

        case .heun:
            return """
            A predictor-corrector method using the average of the beginning and predicted slopes.
            """

        case .rungeKuttaFourth:
            return """
            Uses four slope evaluations per step and generally provides much higher accuracy.
            """
        }
    }
}

struct ODEEquationCoefficients:
    Equatable,
    Hashable {

    let constant: Double
    let xCoefficient: Double
    let yCoefficient: Double
    let xyCoefficient: Double

    func derivative(
        x: Double,
        y: Double
    ) -> Double {
        constant +
        xCoefficient * x +
        yCoefficient * y +
        xyCoefficient * x * y
    }
}

struct ODESolverInput: Equatable {
    let coefficients: ODEEquationCoefficients

    let initialX: Double
    let initialY: Double
    let targetX: Double

    let stepSize: Double
    let maximumSteps: Int
}

struct ODESolutionPoint:
    Identifiable,
    Equatable {

    let step: Int
    let x: Double
    let y: Double
    let derivative: Double

    var id: Int {
        step
    }
}

struct ODESolverResult: Equatable {
    let method: ODESolverMethod
    let points: [ODESolutionPoint]

    let initialX: Double
    let initialY: Double

    let targetX: Double
    let finalX: Double
    let finalY: Double

    let stepSize: Double
    let stepCount: Int

    let adjustedFinalStep: Bool
}
