import SwiftUI
import Charts

struct LinearSystemView: View {
    @State
    private var selectedMethod:
        LinearSystemMethod = .gaussianElimination

    @State private var systemSize = 3

    @State
    private var matrixInputs: [[String]] = [
        ["4", "1", "1"],
        ["2", "5", "2"],
        ["1", "2", "4"]
    ]

    @State
    private var constantInputs = [
        "5",
        "-2",
        "9"
    ]

    @State
    private var initialGuessInputs = [
        "0",
        "0",
        "0"
    ]

    @State private var toleranceInput = "1e-8"
    @State private var maximumIterationsInput = "100"

    @State
    private var result: LinearSystemResult?

    @State private var errorMessage = ""

    private let engine =
        LinearSystemEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "square.grid.3x3.fill",
                    title:
                        "Linear Systems Solver",
                    subtitle:
                        "Gaussian Elimination and Gauss–Seidel",
                    tint: .blue
                )

                methodInformationCard

                CalculatorCard {
                    calculatorContent
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            .padding(
                .horizontal,
                AppTheme.Layout
                    .pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout
                    .pageVerticalPadding
            )
        }
        .navigationTitle("Linear Systems")
        .onChange(of: selectedMethod) { _, _ in
            clearResult()
        }
        .onChange(of: systemSize) { _, _ in
            synchronizeInputs()
            clearResult()
        }
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Solution Method")
                .font(.headline)

            Picker(
                "Solution Method",
                selection: $selectedMethod
            ) {
                ForEach(
                    LinearSystemMethod.allCases
                ) { method in
                    Text(method.pickerTitle)
                        .tag(method)
                }
            }
            .pickerStyle(.segmented)

            Divider()

            systemConfiguration

            Divider()

            matrixSection

            if selectedMethod == .gaussSeidel {
                Divider()
                iterativeSettings
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: AppSpacing.small) {
                    loadExampleButton
                    clearButton
                }

                VStack(spacing: AppSpacing.small) {
                    loadExampleButton
                    clearButton
                }
            }

            PrimaryActionButton(
                title: "Solve System",
                systemImage: "equal.circle.fill",
                action: solveSystem
            )

            if let result {
                resultSection(result)
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private var methodInformationCard:
        some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(selectedMethod.title)
                    .font(.headline)

                Text(selectedMethod.formula)
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)

                Text(selectedMethod.explanation)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(
            maxWidth:
                AppTheme.Layout
                    .calculatorMaxWidth
        )
    }

    private var systemConfiguration:
        some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.xxSmall
            ) {
                Text("System Size")
                    .font(.headline)

                Text("Ax = b")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Picker(
                "System Size",
                selection: $systemSize
            ) {
                ForEach(2...5, id: \.self) {
                    size in

                    Text("\(size) × \(size)")
                        .tag(size)
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var matrixSection: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            Text("Coefficient Matrix and Constants")
                .font(.headline)

            Text(
                "Each row represents one equation."
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            ScrollView(.horizontal) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    matrixHeader

                    ForEach(
                        0..<systemSize,
                        id: \.self
                    ) { row in
                        matrixRow(row)
                    }
                }
                .padding(.bottom, AppSpacing.xSmall)
            }
            .scrollIndicators(.visible)
        }
    }

    private var matrixHeader: some View {
        HStack(spacing: AppSpacing.xSmall) {
            Text("")
                .frame(width: 32)

            ForEach(
                0..<systemSize,
                id: \.self
            ) { column in
                Text("x\(column + 1)")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .frame(width: 76)
            }

            Text("=")
                .frame(width: 20)

            Text("b")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .frame(width: 76)
        }
    }

    private func matrixRow(
        _ row: Int
    ) -> some View {
        HStack(spacing: AppSpacing.xSmall) {
            Text("\(row + 1)")
                .font(
                    .subheadline
                        .monospacedDigit()
                )
                .foregroundStyle(.secondary)
                .frame(width: 32)

            ForEach(
                0..<systemSize,
                id: \.self
            ) { column in
                TextField(
                    "a\(row + 1)\(column + 1)",
                    text: matrixBinding(
                        row: row,
                        column: column
                    )
                )
                .textFieldStyle(.roundedBorder)
                .engineeringNumberKeyboard()
                .frame(width: 76)
                .accessibilityLabel(
                    "Coefficient row \(row + 1), column \(column + 1)"
                )
            }

            Text("=")
                .frame(width: 20)

            TextField(
                "b\(row + 1)",
                text: constantBinding(
                    row: row
                )
            )
            .textFieldStyle(.roundedBorder)
            .engineeringNumberKeyboard()
            .frame(width: 76)
            .accessibilityLabel(
                "Constant for equation \(row + 1)"
            )
        }
    }

    private var iterativeSettings: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            Text("Gauss–Seidel Settings")
                .font(.headline)

            Text("Initial Guess")
                .font(.subheadline.bold())

            ScrollView(.horizontal) {
                HStack(spacing: AppSpacing.small) {
                    ForEach(
                        0..<systemSize,
                        id: \.self
                    ) { index in
                        VStack(
                            alignment: .leading,
                            spacing: AppSpacing.xxSmall
                        ) {
                            Text("x\(index + 1)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            TextField(
                                "0",
                                text:
                                    initialGuessBinding(
                                        index: index
                                    )
                            )
                            .textFieldStyle(.roundedBorder)
                            .engineeringNumberKeyboard()
                            .frame(width: 90)
                        }
                    }
                }
            }

            CalculatorInputField(
                title: "Tolerance",
                symbol: "ε",
                unit: "",
                placeholder: "Example: 1e-8",
                text: $toleranceInput
            )

            CalculatorInputField(
                title: "Maximum Iterations",
                symbol: "N",
                unit: "",
                placeholder: "Example: 100",
                text: $maximumIterationsInput
            )
        }
    }

    private var loadExampleButton: some View {
        Button {
            loadExample()
        } label: {
            Label(
                "Load Example",
                systemImage: "doc.text"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var clearButton: some View {
        Button {
            resetInputs()
        } label: {
            Label(
                "Clear",
                systemImage:
                    "arrow.counterclockwise"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private func resultSection(
        _ result: LinearSystemResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items:
                    result.solution.enumerated()
                        .map { index, value in
                            CalculationResultDisplayItem(
                                label:
                                    "Unknown x\(index + 1)",
                                value:
                                    numberFormatter.format(
                                        value
                                    ),
                                unit: ""
                            )
                        },
                tint:
                    result.converged
                    ? .green
                    : .orange
            )

            if !result.converged {
                CalculatorInfoCard(tint: .orange) {
                    Label(
                        "The method reached the maximum number of iterations before satisfying the requested tolerance.",
                        systemImage:
                            "exclamationmark.triangle.fill"
                    )
                    .foregroundStyle(.orange)
                }
            }

            if !result.history.isEmpty {
                convergenceChart(result)
            }

            resultInformationCard(result)
        }
    }

    private func convergenceChart(
        _ result: LinearSystemResult
    ) -> some View {
        Chart(result.history) { iteration in
            LineMark(
                x: .value(
                    "Iteration",
                    iteration.iteration
                ),
                y: .value(
                    "Residual",
                    iteration.residualNorm
                )
            )

            PointMark(
                x: .value(
                    "Iteration",
                    iteration.iteration
                ),
                y: .value(
                    "Residual",
                    iteration.residualNorm
                )
            )
        }
        .chartXAxisLabel("Iteration")
        .chartYAxisLabel("Residual Norm")
        .frame(height: 260)
        .padding(AppSpacing.small)
        .background(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.large
            )
            .fill(AppTheme.Colors.surface)
        )
        .overlay(
            RoundedRectangle(
                cornerRadius:
                    AppTheme.Radius.large
            )
            .stroke(
                AppTheme.Colors.border,
                lineWidth: 1
            )
        )
    }

    private func resultInformationCard(
        _ result: LinearSystemResult
    ) -> some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                informationRow(
                    title: "Method",
                    value: result.method.title
                )

                Divider()

                informationRow(
                    title: "System Size",
                    value:
                        "\(result.systemSize) × \(result.systemSize)"
                )

                informationRow(
                    title: "Residual Norm",
                    value:
                        numberFormatter.format(
                            result.residualNorm
                        )
                )

                informationRow(
                    title: "Iterations",
                    value:
                        result.method ==
                            .gaussianElimination
                        ? "Direct Method"
                        : "\(result.iterations)"
                )

                informationRow(
                    title: "Status",
                    value:
                        result.converged
                        ? "Converged"
                        : "Not Converged"
                )
            }
        }
    }

    private func informationRow(
        title: String,
        value: String
    ) -> some View {
        HStack(
            alignment: .firstTextBaseline,
            spacing: AppSpacing.medium
        ) {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
    }

    private func solveSystem() {
        clearResult()

        do {
            let input = try makeInput()

            result = try engine.solve(
                method: selectedMethod,
                input: input
            )
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func makeInput() throws
        -> LinearSystemInput {
        let matrix = try matrixInputs
            .enumerated()
            .map { rowIndex, row in
                try row.enumerated().map {
                    columnIndex,
                    text in

                    try InputValidator.parseNumber(
                        text,
                        fieldName:
                            "Coefficient a\(rowIndex + 1)\(columnIndex + 1)"
                    )
                }
            }

        let constants = try constantInputs
            .enumerated()
            .map { index, text in
                try InputValidator.parseNumber(
                    text,
                    fieldName:
                        "Constant b\(index + 1)"
                )
            }

        let initialGuess: [Double]?

        if selectedMethod == .gaussSeidel {
            initialGuess = try initialGuessInputs
                .enumerated()
                .map { index, text in
                    try InputValidator.parseNumber(
                        text,
                        fieldName:
                            "Initial guess x\(index + 1)"
                    )
                }
        } else {
            initialGuess = nil
        }

        let tolerance: Double
        let maximumIterations: Int

        if selectedMethod == .gaussSeidel {
            tolerance =
                try InputValidator.parseNumber(
                    toleranceInput,
                    fieldName: "Tolerance"
                )

            let maximumIterationsValue =
                try InputValidator.parseNumber(
                    maximumIterationsInput,
                    fieldName:
                        "Maximum Iterations"
                )

            guard
                maximumIterationsValue.rounded() ==
                    maximumIterationsValue,
                maximumIterationsValue >= 1,
                maximumIterationsValue <= 10_000
            else {
                throw CalculationError
                    .calculationFailed(
                        reason:
                            "Maximum iterations must be an integer between 1 and 10,000."
                    )
            }

            maximumIterations =
                Int(maximumIterationsValue)
        } else {
            tolerance = 1e-8
            maximumIterations = 100
        }

        return LinearSystemInput(
            coefficientMatrix: matrix,
            constants: constants,
            initialGuess: initialGuess,
            tolerance: tolerance,
            maximumIterations:
                maximumIterations
        )
    }

    private func matrixBinding(
        row: Int,
        column: Int
    ) -> Binding<String> {
        Binding(
            get: {
                matrixInputs[row][column]
            },
            set: {
                matrixInputs[row][column] = $0
                clearResult()
            }
        )
    }

    private func constantBinding(
        row: Int
    ) -> Binding<String> {
        Binding(
            get: {
                constantInputs[row]
            },
            set: {
                constantInputs[row] = $0
                clearResult()
            }
        )
    }

    private func initialGuessBinding(
        index: Int
    ) -> Binding<String> {
        Binding(
            get: {
                initialGuessInputs[index]
            },
            set: {
                initialGuessInputs[index] = $0
                clearResult()
            }
        )
    }

    private func synchronizeInputs() {
        let oldMatrix = matrixInputs
        let oldConstants = constantInputs
        let oldGuesses = initialGuessInputs

        matrixInputs = Array(
            repeating:
                Array(
                    repeating: "",
                    count: systemSize
                ),
            count: systemSize
        )

        constantInputs = Array(
            repeating: "",
            count: systemSize
        )

        initialGuessInputs = Array(
            repeating: "0",
            count: systemSize
        )

        for row in 0..<min(
            oldMatrix.count,
            systemSize
        ) {
            for column in 0..<min(
                oldMatrix[row].count,
                systemSize
            ) {
                matrixInputs[row][column] =
                    oldMatrix[row][column]
            }
        }

        for index in 0..<min(
            oldConstants.count,
            systemSize
        ) {
            constantInputs[index] =
                oldConstants[index]
        }

        for index in 0..<min(
            oldGuesses.count,
            systemSize
        ) {
            initialGuessInputs[index] =
                oldGuesses[index]
        }
    }

    private func loadExample() {
        systemSize = 3

        matrixInputs = [
            ["4", "1", "1"],
            ["2", "5", "2"],
            ["1", "2", "4"]
        ]

        constantInputs = [
            "5",
            "-2",
            "9"
        ]

        initialGuessInputs = [
            "0",
            "0",
            "0"
        ]

        toleranceInput = "1e-8"
        maximumIterationsInput = "100"

        clearResult()
    }

    private func resetInputs() {
        matrixInputs = Array(
            repeating:
                Array(
                    repeating: "",
                    count: systemSize
                ),
            count: systemSize
        )

        constantInputs = Array(
            repeating: "",
            count: systemSize
        )

        initialGuessInputs = Array(
            repeating: "0",
            count: systemSize
        )

        toleranceInput = "1e-8"
        maximumIterationsInput = "100"

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The linear system could not be solved."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LinearSystemView()
    }
}
