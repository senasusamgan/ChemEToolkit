import Testing
@testable import ChemEToolkit

@Suite("Linear System Engine")
struct LinearSystemEngineTests {
    private let engine =
        LinearSystemEngine()

    private let tolerance =
        0.000001

    private var exampleInput:
        LinearSystemInput {
        LinearSystemInput(
            coefficientMatrix: [
                [4, 1, 1],
                [2, 5, 2],
                [1, 2, 4]
            ],
            constants: [
                5,
                -2,
                9
            ],
            initialGuess: [
                0,
                0,
                0
            ],
            tolerance: 1e-10,
            maximumIterations: 500
        )
    }

    @Test("Solves using Gaussian elimination")
    func solvesGaussianElimination()
        throws {

        let result = try engine.solve(
            method: .gaussianElimination,
            input: exampleInput
        )

        #expect(result.converged)

        #expect(
            abs(result.solution[0] - 1) <
            tolerance
        )

        #expect(
            abs(result.solution[1] + 2) <
            tolerance
        )

        #expect(
            abs(result.solution[2] - 3) <
            tolerance
        )

        #expect(
            result.residualNorm <
            tolerance
        )
    }

    @Test("Uses partial pivoting")
    func usesPartialPivoting() throws {
        let input = LinearSystemInput(
            coefficientMatrix: [
                [0, 2],
                [1, 1]
            ],
            constants: [
                4,
                3
            ],
            initialGuess: nil,
            tolerance: 1e-8,
            maximumIterations: 100
        )

        let result = try engine.solve(
            method: .gaussianElimination,
            input: input
        )

        #expect(
            abs(result.solution[0] - 1) <
            tolerance
        )

        #expect(
            abs(result.solution[1] - 2) <
            tolerance
        )
    }

    @Test("Solves using Gauss Seidel")
    func solvesGaussSeidel() throws {
        let result = try engine.solve(
            method: .gaussSeidel,
            input: exampleInput
        )

        #expect(result.converged)
        #expect(result.iterations > 0)

        #expect(
            abs(result.solution[0] - 1) <
            tolerance
        )

        #expect(
            abs(result.solution[1] + 2) <
            tolerance
        )

        #expect(
            abs(result.solution[2] - 3) <
            tolerance
        )
    }

    @Test("Returns exact initial guess")
    func returnsExactInitialGuess()
        throws {

        let input = LinearSystemInput(
            coefficientMatrix: [
                [4, 1],
                [2, 3]
            ],
            constants: [
                9,
                13
            ],
            initialGuess: [
                1.4,
                3.4
            ],
            tolerance: 1e-8,
            maximumIterations: 100
        )

        let result = try engine.solve(
            method: .gaussSeidel,
            input: input
        )

        #expect(result.converged)
        #expect(result.iterations == 0)
    }

    @Test("Rejects singular matrix")
    func rejectsSingularMatrix() {
        let input = LinearSystemInput(
            coefficientMatrix: [
                [1, 2],
                [2, 4]
            ],
            constants: [
                3,
                6
            ],
            initialGuess: nil,
            tolerance: 1e-8,
            maximumIterations: 100
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "The coefficient matrix is singular or nearly singular, so a unique solution cannot be calculated."
                    )
        ) {
            try engine.solve(
                method: .gaussianElimination,
                input: input
            )
        }
    }

    @Test("Rejects non-square matrix")
    func rejectsNonSquareMatrix() {
        let input = LinearSystemInput(
            coefficientMatrix: [
                [1, 2, 3],
                [4, 5, 6]
            ],
            constants: [
                1,
                2
            ],
            initialGuess: nil,
            tolerance: 1e-8,
            maximumIterations: 100
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "The coefficient matrix must be square."
                    )
        ) {
            try engine.solve(
                method: .gaussianElimination,
                input: input
            )
        }
    }

    @Test("Rejects zero Gauss Seidel diagonal")
    func rejectsZeroDiagonal() {
        let input = LinearSystemInput(
            coefficientMatrix: [
                [0, 1],
                [1, 2]
            ],
            constants: [
                1,
                3
            ],
            initialGuess: [
                0,
                0
            ],
            tolerance: 1e-8,
            maximumIterations: 100
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Gauss–Seidel requires every diagonal coefficient to be non-zero."
                    )
        ) {
            try engine.solve(
                method: .gaussSeidel,
                input: input
            )
        }
    }

    @Test("Returns non-converged iterative result")
    func returnsNonConvergedResult()
        throws {

        let input = LinearSystemInput(
            coefficientMatrix: [
                [1, 2],
                [2, 1]
            ],
            constants: [
                3,
                3
            ],
            initialGuess: [
                0,
                0
            ],
            tolerance: 1e-15,
            maximumIterations: 1
        )

        let result = try engine.solve(
            method: .gaussSeidel,
            input: input
        )

        #expect(result.converged == false)
        #expect(result.iterations == 1)
    }
}
