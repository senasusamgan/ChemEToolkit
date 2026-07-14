import SwiftUI
import Charts

struct RootFindingView: View {
    @State
    private var selectedMethod:
        RootFindingMethod = .bisection

    @State
    private var polynomialDegree = 2

    @State
    private var coefficientInputs = [
        "-2",
        "0",
        "1"
    ]

    @State private var lowerBoundInput = "0"
    @State private var upperBoundInput = "2"

    @State private var initialGuessInput = "1"
    @State private var secondGuessInput = "2"

    @State private var toleranceInput = "1e-8"
    @State private var maximumIterationsInput = "100"

    @State
    private var result: RootFindingResult?

    @State private var errorMessage = ""

    private let engine =
        RootFindingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scope",
                    title: "Polynomial Root Finding",
                    subtitle:
                        "Bisection, Newton–Raphson and Secant Methods",
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
        .navigationTitle("Root Finding")
        .onChange(of: selectedMethod) { _, _ in
            clearResult()
        }
        .onChange(of: polynomialDegree) { _, _ in
            synchronizeCoefficientInputs()
            clearResult()
        }
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Numerical Method")
                .font(.headline)

            Picker(
                "Numerical Method",
                selection: $selectedMethod
            ) {
                ForEach(
                    RootFindingMethod.allCases
                ) { method in
                    Text(method.pickerTitle)
                        .tag(method)
                }
            }
            .pickerStyle(.segmented)

            Divider()

            polynomialSection

            Divider()

            methodInputFields

            Divider()

            convergenceSettings

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
                title: "Find Root",
                systemImage: "scope",
                action: calculateRoot
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

    private var methodInformationCard: some View {
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

    private var polynomialSection: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            HStack {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.xxSmall
                ) {
                    Text("Polynomial")
                        .font(.headline)

                    Text(
                        "f(x) = a₀ + a₁x + a₂x² + …"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Spacer()

                Picker(
                    "Degree",
                    selection: $polynomialDegree
                ) {
                    ForEach(1...6, id: \.self) {
                        degree in

                        Text("Degree \(degree)")
                            .tag(degree)
                    }
                }
                .pickerStyle(.menu)
            }

            ForEach(
                0...polynomialDegree,
                id: \.self
            ) { power in
                CalculatorInputField(
                    title: coefficientTitle(
                        power: power
                    ),
                    symbol: coefficientSymbol(
                        power: power
                    ),
                    unit: "",
                    placeholder:
                        "Enter coefficient",
                    text:
                        $coefficientInputs[power]
                )
            }

            Text(
                "Coefficients are entered from the constant term upward."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var methodInputFields: some View {
        switch selectedMethod {
        case .bisection:
            CalculatorInputField(
                title: "Lower Bound",
                symbol: "a",
                unit: "",
                placeholder:
                    "Enter lower interval bound",
                text: $lowerBoundInput
            )

            CalculatorInputField(
                title: "Upper Bound",
                symbol: "b",
                unit: "",
                placeholder:
                    "Enter upper interval bound",
                text: $upperBoundInput
            )

        case .newtonRaphson:
            CalculatorInputField(
                title: "Initial Guess",
                symbol: "x₀",
                unit: "",
                placeholder:
                    "Enter initial guess",
                text: $initialGuessInput
            )

        case .secant:
            CalculatorInputField(
                title: "First Guess",
                symbol: "x₀",
                unit: "",
                placeholder:
                    "Enter first guess",
                text: $initialGuessInput
            )

            CalculatorInputField(
                title: "Second Guess",
                symbol: "x₁",
                unit: "",
                placeholder:
                    "Enter second guess",
                text: $secondGuessInput
            )
        }
    }

    private var convergenceSettings: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            Text("Convergence Settings")
                .font(.headline)

            CalculatorInputField(
                title: "Tolerance",
                symbol: "ε",
                unit: "",
                placeholder:
                    "Example: 1e-8",
                text: $toleranceInput
            )

            CalculatorInputField(
                title: "Maximum Iterations",
                symbol: "N",
                unit: "",
                placeholder:
                    "Example: 100",
                text:
                    $maximumIterationsInput
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
        _ result: RootFindingResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "Approximate Root",
                        value:
                            numberFormatter.format(
                                result.root
                            ),
                        unit: "x"
                    ),
                    CalculationResultDisplayItem(
                        label: "Residual",
                        value:
                            numberFormatter.format(
                                result.functionValue
                            ),
                        unit: "f(x)"
                    ),
                    CalculationResultDisplayItem(
                        label: "Iterations",
                        value:
                            "\(result.iterations)",
                        unit: ""
                    )
                ],
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
        _ result: RootFindingResult
    ) -> some View {
        Chart(result.history) { item in
            LineMark(
                x: .value(
                    "Iteration",
                    item.iteration
                ),
                y: .value(
                    "Absolute Residual",
                    abs(item.functionValue)
                )
            )

            PointMark(
                x: .value(
                    "Iteration",
                    item.iteration
                ),
                y: .value(
                    "Absolute Residual",
                    abs(item.functionValue)
                )
            )
        }
        .chartXAxisLabel("Iteration")
        .chartYAxisLabel("|f(x)|")
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
        _ result: RootFindingResult
    ) -> some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                informationRow(
                    title: "Method",
                    value: result.method.title
                )

                Divider()

                informationRow(
                    title: "Polynomial Degree",
                    value:
                        "\(result.polynomialDegree)"
                )

                informationRow(
                    title: "Tolerance",
                    value:
                        numberFormatter.format(
                            result.tolerance
                        )
                )

                informationRow(
                    title: "Status",
                    value:
                        result.converged
                        ? "Converged"
                        : "Not Converged"
                )

                if let finalIteration =
                    result.history.last {
                    informationRow(
                        title:
                            "Final Estimated Error",
                        value:
                            numberFormatter.format(
                                finalIteration
                                    .estimatedError
                            )
                    )
                }
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

    private func coefficientTitle(
        power: Int
    ) -> String {
        switch power {
        case 0:
            return "Constant Term"

        case 1:
            return "Linear Coefficient"

        default:
            return "Power \(power) Coefficient"
        }
    }

    private func coefficientSymbol(
        power: Int
    ) -> String {
        "a\(power)"
    }

    private func calculateRoot() {
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
        -> RootFindingInput {
        let coefficients = try coefficientInputs
            .enumerated()
            .map { index, text in
                try InputValidator.parseNumber(
                    text,
                    fieldName:
                        "Coefficient a\(index)"
                )
            }

        let tolerance =
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
            throw CalculationError.calculationFailed(
                reason:
                    "Maximum iterations must be an integer between 1 and 10,000."
            )
        }

        return RootFindingInput(
            coefficients: coefficients,
            lowerBound:
                try optionalMethodValue(
                    lowerBoundInput,
                    required:
                        selectedMethod ==
                        .bisection,
                    fieldName: "Lower Bound"
                ),
            upperBound:
                try optionalMethodValue(
                    upperBoundInput,
                    required:
                        selectedMethod ==
                        .bisection,
                    fieldName: "Upper Bound"
                ),
            initialGuess:
                try optionalMethodValue(
                    initialGuessInput,
                    required:
                        selectedMethod !=
                        .bisection,
                    fieldName:
                        selectedMethod == .secant
                        ? "First Guess"
                        : "Initial Guess"
                ),
            secondGuess:
                try optionalMethodValue(
                    secondGuessInput,
                    required:
                        selectedMethod ==
                        .secant,
                    fieldName: "Second Guess"
                ),
            tolerance: tolerance,
            maximumIterations:
                Int(maximumIterationsValue)
        )
    }

    private func optionalMethodValue(
        _ text: String,
        required: Bool,
        fieldName: String
    ) throws -> Double? {
        guard required else {
            return nil
        }

        return try InputValidator.parseNumber(
            text,
            fieldName: fieldName
        )
    }

    private func synchronizeCoefficientInputs() {
        let requiredCount =
            polynomialDegree + 1

        if coefficientInputs.count <
            requiredCount {
            coefficientInputs.append(
                contentsOf:
                    Array(
                        repeating: "0",
                        count:
                            requiredCount -
                            coefficientInputs.count
                    )
            )
        } else if coefficientInputs.count >
                    requiredCount {
            coefficientInputs =
                Array(
                    coefficientInputs.prefix(
                        requiredCount
                    )
                )
        }
    }

    private func loadExample() {
        polynomialDegree = 2
        coefficientInputs = [
            "-2",
            "0",
            "1"
        ]

        lowerBoundInput = "0"
        upperBoundInput = "2"

        initialGuessInput = "1"
        secondGuessInput = "2"

        toleranceInput = "1e-8"
        maximumIterationsInput = "100"

        clearResult()
    }

    private func resetInputs() {
        polynomialDegree = 2
        coefficientInputs = [
            "",
            "",
            ""
        ]

        lowerBoundInput = ""
        upperBoundInput = ""

        initialGuessInput = ""
        secondGuessInput = ""

        toleranceInput = "1e-8"
        maximumIterationsInput = "100"

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The root calculation could not be completed."

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
        RootFindingView()
    }
}
