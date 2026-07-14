import Foundation

enum LinearSystemMethod:
    String,
    CaseIterable,
    Identifiable,
    Codable,
    Hashable {

    case gaussianElimination
    case gaussSeidel
    case jacobi

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .gaussianElimination:
            return "Gaussian Elimination"

        case .gaussSeidel:
            return "Gauss–Seidel Method"

        case .jacobi:
            return "Jacobi Method"
        }
    }

    var pickerTitle: String {
        switch self {
        case .gaussianElimination:
            return "Gaussian"

        case .gaussSeidel:
            return "Gauss–Seidel"

        case .jacobi:
            return "Jacobi"
        }
    }

    var formula: String {
        switch self {
        case .gaussianElimination:
            return """
            Ax = b → Upper Triangular Form → Back Substitution
            """

        case .gaussSeidel:
            return """
            xᵢ⁽ᵏ⁺¹⁾ = [bᵢ − Σⱼ<i aᵢⱼxⱼ⁽ᵏ⁺¹⁾ − Σⱼ>i aᵢⱼxⱼ⁽ᵏ⁾] / aᵢᵢ
            """

        case .jacobi:
            return """
            xᵢ⁽ᵏ⁺¹⁾ = [bᵢ − Σⱼ≠ᵢ aᵢⱼxⱼ⁽ᵏ⁾] / aᵢᵢ
            """
        }
    }

    var explanation: String {
        switch self {
        case .gaussianElimination:
            return """
            Solves a square linear system directly using partial pivoting for improved numerical stability.
            """

        case .gaussSeidel:
            return """
            Updates each unknown iteratively using the newest available estimates. Diagonally dominant systems generally converge more reliably.
            """

        case .jacobi:
            return """
            Calculates every new estimate using only values from the previous iteration. It is simple and parallelizable, but usually converges more slowly than Gauss–Seidel.
            """
        }
    }

    var isIterative: Bool {
        switch self {
        case .gaussianElimination:
            return false

        case .gaussSeidel, .jacobi:
            return true
        }
    }
}

struct LinearSystemInput: Equatable {
    let coefficientMatrix: [[Double]]
    let constants: [Double]

    let initialGuess: [Double]?

    let tolerance: Double
    let maximumIterations: Int
}

struct LinearSystemIteration:
    Identifiable,
    Equatable {

    let iteration: Int
    let estimates: [Double]

    let residualNorm: Double
    let maximumChange: Double

    var id: Int {
        iteration
    }
}

struct LinearSystemResult: Equatable {
    let method: LinearSystemMethod

    let solution: [Double]
    let residualNorm: Double

    let iterations: Int
    let converged: Bool

    let systemSize: Int
    let history: [LinearSystemIteration]
}
