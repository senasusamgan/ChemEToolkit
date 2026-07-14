import Foundation

struct LinearSystemEngine {
    private let singularityThreshold = 1e-14

    func solve(
        method: LinearSystemMethod,
        input: LinearSystemInput
    ) throws -> LinearSystemResult {
        try validateSystem(input)

        switch method {
        case .gaussianElimination:
            return try solveGaussianElimination(
                input: input
            )

        case .gaussSeidel:
            return try solveIterative(
                method: .gaussSeidel,
                input: input
            )

        case .jacobi:
            return try solveIterative(
                method: .jacobi,
                input: input
            )
        }
    }

    // MARK: - Gaussian Elimination

    private func solveGaussianElimination(
        input: LinearSystemInput
    ) throws -> LinearSystemResult {
        let size =
            input.coefficientMatrix.count

        var augmentedMatrix = zip(
            input.coefficientMatrix,
            input.constants
        )
        .map { row, constant in
            row + [constant]
        }

        for pivotIndex in 0..<size {
            guard let pivotRow = (
                pivotIndex..<size
            ).max(
                by: {
                    abs(
                        augmentedMatrix[
                            $0
                        ][pivotIndex]
                    ) <
                    abs(
                        augmentedMatrix[
                            $1
                        ][pivotIndex]
                    )
                }
            ) else {
                throw singularSystemError
            }

            let pivotValue =
                augmentedMatrix[
                    pivotRow
                ][pivotIndex]

            let pivotScale = max(
                1,
                augmentedMatrix[pivotRow]
                    .dropLast()
                    .map(abs)
                    .max() ?? 1
            )

            guard abs(pivotValue) >
                    singularityThreshold *
                    pivotScale else {
                throw singularSystemError
            }

            if pivotRow != pivotIndex {
                augmentedMatrix.swapAt(
                    pivotRow,
                    pivotIndex
                )
            }

            guard pivotIndex <
                    size - 1 else {
                continue
            }

            for rowIndex in
                (pivotIndex + 1)..<size {

                let factor =
                    augmentedMatrix[
                        rowIndex
                    ][pivotIndex] /
                    augmentedMatrix[
                        pivotIndex
                    ][pivotIndex]

                augmentedMatrix[
                    rowIndex
                ][pivotIndex] = 0

                for columnIndex in
                    (pivotIndex + 1)...size {

                    augmentedMatrix[
                        rowIndex
                    ][columnIndex] -=
                        factor *
                        augmentedMatrix[
                            pivotIndex
                        ][columnIndex]
                }
            }
        }

        var solution = Array(
            repeating: 0.0,
            count: size
        )

        for rowIndex in stride(
            from: size - 1,
            through: 0,
            by: -1
        ) {
            var rightHandSide =
                augmentedMatrix[
                    rowIndex
                ][size]

            if rowIndex < size - 1 {
                for columnIndex in
                    (rowIndex + 1)..<size {

                    rightHandSide -=
                        augmentedMatrix[
                            rowIndex
                        ][columnIndex] *
                        solution[
                            columnIndex
                        ]
                }
            }

            let diagonal =
                augmentedMatrix[
                    rowIndex
                ][rowIndex]

            guard abs(diagonal) >
                    singularityThreshold else {
                throw singularSystemError
            }

            solution[rowIndex] =
                try InputValidator
                    .validateResult(
                        rightHandSide /
                        diagonal
                    )
        }

        let residualNorm =
            try InputValidator
                .validateResult(
                    residualInfinityNorm(
                        matrix:
                            input.coefficientMatrix,
                        constants:
                            input.constants,
                        solution:
                            solution
                    )
                )

        return LinearSystemResult(
            method:
                .gaussianElimination,
            solution: solution,
            residualNorm: residualNorm,
            iterations: 0,
            converged: true,
            systemSize: size,
            history: []
        )
    }

    // MARK: - Iterative Methods

    private func solveIterative(
        method: LinearSystemMethod,
        input: LinearSystemInput
    ) throws -> LinearSystemResult {
        let matrix =
            input.coefficientMatrix

        let constants =
            input.constants

        let size =
            matrix.count

        let configuration =
            try validatedIterativeConfiguration(
                method: method,
                input: input
            )

        let tolerance =
            configuration.tolerance

        var estimates =
            configuration.initialGuess

        var history:
            [LinearSystemIteration] = []

        let initialResidual =
            try InputValidator
                .validateResult(
                    residualInfinityNorm(
                        matrix: matrix,
                        constants: constants,
                        solution: estimates
                    )
                )

        if initialResidual <= tolerance {
            return LinearSystemResult(
                method: method,
                solution: estimates,
                residualNorm:
                    initialResidual,
                iterations: 0,
                converged: true,
                systemSize: size,
                history: []
            )
        }

        for iteration in
            1...input.maximumIterations {

            let previousEstimates =
                estimates

            switch method {
            case .gaussSeidel:
                estimates =
                    try calculateGaussSeidelIteration(
                        matrix: matrix,
                        constants: constants,
                        previousEstimates:
                            previousEstimates
                    )

            case .jacobi:
                estimates =
                    try calculateJacobiIteration(
                        matrix: matrix,
                        constants: constants,
                        previousEstimates:
                            previousEstimates
                    )

            case .gaussianElimination:
                throw CalculationError
                    .calculationFailed(
                        reason:
                            "Gaussian Elimination is not an iterative method."
                    )
            }

            let maximumChange =
                try InputValidator
                    .validateResult(
                        zip(
                            estimates,
                            previousEstimates
                        )
                        .map {
                            abs($0 - $1)
                        }
                        .max() ?? 0
                    )

            let residualNorm =
                try InputValidator
                    .validateResult(
                        residualInfinityNorm(
                            matrix: matrix,
                            constants:
                                constants,
                            solution:
                                estimates
                        )
                    )

            history.append(
                LinearSystemIteration(
                    iteration: iteration,
                    estimates: estimates,
                    residualNorm:
                        residualNorm,
                    maximumChange:
                        maximumChange
                )
            )

            if residualNorm <= tolerance &&
                maximumChange <= tolerance {

                return LinearSystemResult(
                    method: method,
                    solution: estimates,
                    residualNorm:
                        residualNorm,
                    iterations: iteration,
                    converged: true,
                    systemSize: size,
                    history: history
                )
            }
        }

        let finalResidual =
            try InputValidator
                .validateResult(
                    history.last?
                        .residualNorm ??
                    residualInfinityNorm(
                        matrix: matrix,
                        constants: constants,
                        solution: estimates
                    )
                )

        return LinearSystemResult(
            method: method,
            solution: estimates,
            residualNorm:
                finalResidual,
            iterations:
                input.maximumIterations,
            converged: false,
            systemSize: size,
            history: history
        )
    }

    private func calculateGaussSeidelIteration(
        matrix: [[Double]],
        constants: [Double],
        previousEstimates: [Double]
    ) throws -> [Double] {
        let size = matrix.count

        var updatedEstimates =
            previousEstimates

        for rowIndex in 0..<size {
            var adjustedConstant =
                constants[rowIndex]

            for columnIndex in 0..<size
            where columnIndex != rowIndex {
                let estimate: Double

                if columnIndex < rowIndex {
                    estimate =
                        updatedEstimates[
                            columnIndex
                        ]
                } else {
                    estimate =
                        previousEstimates[
                            columnIndex
                        ]
                }

                adjustedConstant -=
                    matrix[
                        rowIndex
                    ][columnIndex] *
                    estimate
            }

            updatedEstimates[rowIndex] =
                try InputValidator
                    .validateResult(
                        adjustedConstant /
                        matrix[
                            rowIndex
                        ][rowIndex]
                    )
        }

        return updatedEstimates
    }

    private func calculateJacobiIteration(
        matrix: [[Double]],
        constants: [Double],
        previousEstimates: [Double]
    ) throws -> [Double] {
        let size = matrix.count

        var updatedEstimates = Array(
            repeating: 0.0,
            count: size
        )

        for rowIndex in 0..<size {
            var adjustedConstant =
                constants[rowIndex]

            for columnIndex in 0..<size
            where columnIndex != rowIndex {
                adjustedConstant -=
                    matrix[
                        rowIndex
                    ][columnIndex] *
                    previousEstimates[
                        columnIndex
                    ]
            }

            updatedEstimates[rowIndex] =
                try InputValidator
                    .validateResult(
                        adjustedConstant /
                        matrix[
                            rowIndex
                        ][rowIndex]
                    )
        }

        return updatedEstimates
    }

    private func validatedIterativeConfiguration(
        method: LinearSystemMethod,
        input: LinearSystemInput
    ) throws -> (
        tolerance: Double,
        initialGuess: [Double]
    ) {
        let size =
            input.coefficientMatrix.count

        let tolerance =
            try InputValidator
                .requirePositive(
                    input.tolerance,
                    fieldName: "Tolerance"
                )

        guard
            input.maximumIterations >= 1,
            input.maximumIterations <= 10_000
        else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "Maximum iterations must be an integer between 1 and 10,000."
                )
        }

        guard let initialGuess =
                input.initialGuess else {
            throw CalculationError
                .emptyField(
                    fieldName:
                        "Initial Guess"
                )
        }

        guard initialGuess.count ==
                size else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "The initial guess must contain one value for each unknown."
                )
        }

        guard initialGuess.allSatisfy({
            $0.isFinite
        }) else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "All initial guess values must be finite numbers."
                )
        }

        for index in 0..<size {
            let diagonal =
                input.coefficientMatrix[
                    index
                ][index]

            let rowScale = max(
                1,
                input.coefficientMatrix[
                    index
                ]
                .map(abs)
                .max() ?? 1
            )

            guard abs(diagonal) >
                    singularityThreshold *
                    rowScale else {
                throw CalculationError
                    .calculationFailed(
                        reason:
                            "\(method.title) requires every diagonal coefficient to be non-zero."
                    )
            }
        }

        return (
            tolerance: tolerance,
            initialGuess:
                initialGuess
        )
    }

    // MARK: - Validation

    private func validateSystem(
        _ input: LinearSystemInput
    ) throws {
        let size =
            input.coefficientMatrix.count

        guard size >= 2 else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "The linear system must contain at least two equations."
                )
        }

        guard input.coefficientMatrix
            .allSatisfy({
                $0.count == size
            }) else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "The coefficient matrix must be square."
                )
        }

        guard input.constants.count ==
                size else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "The constants vector must contain one value for each equation."
                )
        }

        let matrixIsFinite =
            input.coefficientMatrix
                .flatMap { $0 }
                .allSatisfy {
                    $0.isFinite
                }

        let constantsAreFinite =
            input.constants
                .allSatisfy {
                    $0.isFinite
                }

        guard
            matrixIsFinite,
            constantsAreFinite
        else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "All matrix and constant values must be finite numbers."
                )
        }
    }

    // MARK: - Residual

    private func residualInfinityNorm(
        matrix: [[Double]],
        constants: [Double],
        solution: [Double]
    ) -> Double {
        matrix.indices
            .map { rowIndex in
                let calculatedValue =
                    zip(
                        matrix[rowIndex],
                        solution
                    )
                    .reduce(0.0) {
                        partialResult,
                        pair in

                        partialResult +
                        pair.0 * pair.1
                    }

                return abs(
                    calculatedValue -
                    constants[rowIndex]
                )
            }
            .max() ?? 0
    }

    private var singularSystemError:
        CalculationError {
        CalculationError
            .calculationFailed(
                reason:
                    "The coefficient matrix is singular or nearly singular, so a unique solution cannot be calculated."
            )
    }
}
