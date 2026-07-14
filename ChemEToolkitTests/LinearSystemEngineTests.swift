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

        let result =
            try engine.solve(
                method:
                    .gaussianElimination,
                input: exampleInput
            )

        #expect(result.converged)
        #expect(result.iterations == 0)
        #expect(result.history.isEmpty)

        #expect(
            abs(
                result.solution[0] - 1
            ) < tolerance
        )

        #expect(
            abs(
                result.solution[1] + 2
            ) < tolerance
        )

        #expect(
            abs(
                result.solution[2] - 3
            ) < tolerance
        )

        #expect(
            result.residualNorm <
                tolerance
        )
    }

    @Test("Uses partial pivoting")
    func usesPartialPivoting()
        throws {

        let input =
            LinearSystemInput(
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

        let result =
            try engine.solve(
                method:
                    .gaussianElimination,
                input: input
            )

        #expect(
            abs(
                result.solution[0] - 1
            ) < tolerance
        )

        #expect(
            abs(
                result.solution[1] - 2
            ) < tolerance
        )
    }

    @Test("Solves using Gauss Seidel")
    func solvesGaussSeidel()
        throws {

        let result =
            try engine.solve(
                method: .gaussSeidel,
                input: exampleInput
            )

        #expect(result.converged)
        #expect(result.iterations > 0)
        #expect(!result.history.isEmpty)

        #expect(
            abs(
                result.solution[0] - 1
            ) < tolerance
        )

        #expect(
            abs(
                result.solution[1] + 2
            ) < tolerance
        )

        #expect(
            abs(
                result.solution[2] - 3
            ) < tolerance
        )

        #expect(
            result.residualNorm <
                tolerance
        )
    }

    @Test("Solves using Jacobi")
    func solvesJacobi()
        throws {

        let result =
            try engine.solve(
                method: .jacobi,
                input: exampleInput
            )

        #expect(result.method == .jacobi)
        #expect(result.converged)
        #expect(result.iterations > 0)
        #expect(!result.history.isEmpty)

        #expect(
            abs(
                result.solution[0] - 1
            ) < tolerance
        )

        #expect(
            abs(
                result.solution[1] + 2
            ) < tolerance
        )

        #expect(
            abs(
                result.solution[2] - 3
            ) < tolerance
        )

        #expect(
            result.residualNorm <
                tolerance
        )
    }

    @Test("Jacobi uses only previous iteration values")
    func jacobiUsesPreviousValues()
        throws {

        let input =
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
                tolerance: 1e-15,
                maximumIterations: 1
            )

        let result =
            try engine.solve(
                method: .jacobi,
                input: input
            )

        let firstIteration =
            try #require(
                result.history.first
            )

        #expect(
            abs(
                firstIteration
                    .estimates[0] -
                1.25
            ) < tolerance
        )

        #expect(
            abs(
                firstIteration
                    .estimates[1] +
                0.4
            ) < tolerance
        )

        #expect(
            abs(
                firstIteration
                    .estimates[2] -
                2.25
            ) < tolerance
        )
    }

    @Test("Gauss Seidel uses newest iteration values")
    func gaussSeidelUsesNewestValues()
        throws {

        let input =
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
                tolerance: 1e-15,
                maximumIterations: 1
            )

        let result =
            try engine.solve(
                method: .gaussSeidel,
                input: input
            )

        let firstIteration =
            try #require(
                result.history.first
            )

        #expect(
            abs(
                firstIteration
                    .estimates[0] -
                1.25
            ) < tolerance
        )

        #expect(
            abs(
                firstIteration
                    .estimates[1] +
                0.9
            ) < tolerance
        )

        #expect(
            abs(
                firstIteration
                    .estimates[2] -
                2.3875
            ) < tolerance
        )
    }

    @Test("Gauss Seidel returns exact initial guess")
    func gaussSeidelReturnsExactInitialGuess()
        throws {

        let input =
            exactInitialGuessInput

        let result =
            try engine.solve(
                method: .gaussSeidel,
                input: input
            )

        #expect(result.converged)
        #expect(result.iterations == 0)
        #expect(result.history.isEmpty)
    }

    @Test("Jacobi returns exact initial guess")
    func jacobiReturnsExactInitialGuess()
        throws {

        let input =
            exactInitialGuessInput

        let result =
            try engine.solve(
                method: .jacobi,
                input: input
            )

        #expect(result.converged)
        #expect(result.iterations == 0)
        #expect(result.history.isEmpty)
    }

    @Test("Rejects singular matrix")
    func rejectsSingularMatrix() {
        let input =
            LinearSystemInput(
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
                method:
                    .gaussianElimination,
                input: input
            )
        }
    }

    @Test("Rejects non-square matrix")
    func rejectsNonSquareMatrix() {
        let input =
            LinearSystemInput(
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
                method:
                    .gaussianElimination,
                input: input
            )
        }
    }

    @Test("Rejects zero Gauss Seidel diagonal")
    func rejectsZeroGaussSeidelDiagonal() {
        let input =
            zeroDiagonalInput

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Gauss–Seidel Method requires every diagonal coefficient to be non-zero."
                    )
        ) {
            try engine.solve(
                method: .gaussSeidel,
                input: input
            )
        }
    }

    @Test("Rejects zero Jacobi diagonal")
    func rejectsZeroJacobiDiagonal() {
        let input =
            zeroDiagonalInput

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "Jacobi Method requires every diagonal coefficient to be non-zero."
                    )
        ) {
            try engine.solve(
                method: .jacobi,
                input: input
            )
        }
    }

    @Test("Gauss Seidel returns non-converged result")
    func gaussSeidelReturnsNonConvergedResult()
        throws {

        let result =
            try engine.solve(
                method: .gaussSeidel,
                input:
                    nonConvergentInput
            )

        #expect(
            result.converged == false
        )

        #expect(result.iterations == 1)
        #expect(result.history.count == 1)
    }

    @Test("Jacobi returns non-converged result")
    func jacobiReturnsNonConvergedResult()
        throws {

        let result =
            try engine.solve(
                method: .jacobi,
                input:
                    nonConvergentInput
            )

        #expect(
            result.converged == false
        )

        #expect(result.iterations == 1)
        #expect(result.history.count == 1)
    }

    private var exactInitialGuessInput:
        LinearSystemInput {
        LinearSystemInput(
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
    }

    private var zeroDiagonalInput:
        LinearSystemInput {
        LinearSystemInput(
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
    }

    private var nonConvergentInput:
        LinearSystemInput {
        LinearSystemInput(
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
    }
}
