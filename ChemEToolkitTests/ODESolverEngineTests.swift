import Testing
@testable import ChemEToolkit

@Suite("ODE Solver Engine")
struct ODESolverEngineTests {
    private let engine =
        ODESolverEngine()

    private let tolerance =
        0.00000001

    private var exponentialInput:
        ODESolverInput {
        ODESolverInput(
            coefficients:
                ODEEquationCoefficients(
                    constant: 0,
                    xCoefficient: 0,
                    yCoefficient: 1,
                    xyCoefficient: 0
                ),
            initialX: 0,
            initialY: 1,
            targetX: 1,
            stepSize: 0.1,
            maximumSteps: 100
        )
    }

    @Test("Solves using Euler method")
    func solvesEulerMethod() throws {
        let result = try engine.solve(
            method: .euler,
            input: exponentialInput
        )

        #expect(result.stepCount == 10)

        #expect(
            abs(
                result.finalY -
                2.5937424601
            ) < tolerance
        )
    }

    @Test("Solves using Heun method")
    func solvesHeunMethod() throws {
        let result = try engine.solve(
            method: .heun,
            input: exponentialInput
        )

        #expect(
            abs(
                result.finalY -
                2.714080846608224
            ) < tolerance
        )
    }

    @Test("Solves using fourth-order Runge Kutta")
    func solvesRungeKuttaMethod() throws {
        let result = try engine.solve(
            method: .rungeKuttaFourth,
            input: exponentialInput
        )

        #expect(
            abs(
                result.finalY -
                2.718279744135166
            ) < tolerance
        )
    }

    @Test("Adjusts final step")
    func adjustsFinalStep() throws {
        let input = ODESolverInput(
            coefficients:
                ODEEquationCoefficients(
                    constant: 1,
                    xCoefficient: 0,
                    yCoefficient: 0,
                    xyCoefficient: 0
                ),
            initialX: 0,
            initialY: 0,
            targetX: 1,
            stepSize: 0.3,
            maximumSteps: 100
        )

        let result = try engine.solve(
            method: .euler,
            input: input
        )

        #expect(result.adjustedFinalStep)
        #expect(result.stepCount == 4)

        #expect(
            abs(result.finalX - 1) <
            tolerance
        )

        #expect(
            abs(result.finalY - 1) <
            tolerance
        )
    }

    @Test("Supports backward integration")
    func supportsBackwardIntegration()
        throws {

        let input = ODESolverInput(
            coefficients:
                ODEEquationCoefficients(
                    constant: 1,
                    xCoefficient: 0,
                    yCoefficient: 0,
                    xyCoefficient: 0
                ),
            initialX: 1,
            initialY: 1,
            targetX: 0,
            stepSize: 0.25,
            maximumSteps: 100
        )

        let result = try engine.solve(
            method: .rungeKuttaFourth,
            input: input
        )

        #expect(
            abs(result.finalX) <
            tolerance
        )

        #expect(
            abs(result.finalY) <
            tolerance
        )
    }

    @Test("Rejects zero step size")
    func rejectsZeroStepSize() {
        let input = ODESolverInput(
            coefficients:
                exponentialInput.coefficients,
            initialX: 0,
            initialY: 1,
            targetX: 1,
            stepSize: 0,
            maximumSteps: 100
        )

        #expect(
            throws:
                CalculationError
                    .valueMustBePositive(
                        fieldName: "Step Size"
                    )
        ) {
            try engine.solve(
                method: .euler,
                input: input
            )
        }
    }

    @Test("Rejects identical interval bounds")
    func rejectsIdenticalBounds() {
        let input = ODESolverInput(
            coefficients:
                exponentialInput.coefficients,
            initialX: 1,
            initialY: 1,
            targetX: 1,
            stepSize: 0.1,
            maximumSteps: 100
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "The target x value must be different from the initial x value."
                    )
        ) {
            try engine.solve(
                method: .euler,
                input: input
            )
        }
    }

    @Test("Rejects insufficient maximum steps")
    func rejectsInsufficientMaximumSteps() {
        let input = ODESolverInput(
            coefficients:
                exponentialInput.coefficients,
            initialX: 0,
            initialY: 1,
            targetX: 10,
            stepSize: 0.1,
            maximumSteps: 2
        )

        #expect(
            throws:
                CalculationError
                    .calculationFailed(
                        reason:
                            "The required number of steps exceeds the selected maximum."
                    )
        ) {
            try engine.solve(
                method: .euler,
                input: input
            )
        }
    }
}
