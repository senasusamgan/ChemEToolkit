import SwiftUI
import Charts

struct ODESolverView: View {
    @State
    private var selectedMethod:
        ODESolverMethod = .rungeKuttaFourth

    @State private var constantInput = "0"
    @State private var xCoefficientInput = "0"
    @State private var yCoefficientInput = "1"
    @State private var xyCoefficientInput = "0"

    @State private var initialXInput = "0"
    @State private var initialYInput = "1"
    @State private var targetXInput = "1"

    @State private var stepSizeInput = "0.1"
    @State private var maximumStepsInput = "10000"

    @State
    private var result: ODESolverResult?

    @State private var errorMessage = ""

    private let engine =
        ODESolverEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "waveform.path.ecg",
                    title:
                        "First-Order ODE Solver",
                    subtitle:
                        "Euler, Heun and Runge–Kutta Methods",
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
        .navigationTitle("ODE Solver")
        .onChange(of: selectedMethod) { _, _ in
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
                    ODESolverMethod.allCases
                ) { method in
                    Text(method.pickerTitle)
                        .tag(method)
                }
            }
            .pickerStyle(.segmented)

            Divider()

            equationSection

            Divider()

            initialConditionSection

            Divider()

            numericalSettings

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
                title: "Solve ODE",
                systemImage: "waveform.path.ecg",
                action: solveEquation
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

    private var equationSection: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            Text("Differential Equation")
                .font(.headline)

            CalculatorInfoCard(tint: .blue) {
                Text(
                    "dy/dx = a + bx + cy + dxy"
                )
                .font(
                    .system(
                        size: 23,
                        weight: .semibold
                    )
                )
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            }

            CalculatorInputField(
                title: "Constant Term",
                symbol: "a",
                unit: "",
                placeholder:
                    "Enter constant term",
                text: $constantInput
            )

            CalculatorInputField(
                title: "x Coefficient",
                symbol: "b",
                unit: "",
                placeholder:
                    "Enter x coefficient",
                text: $xCoefficientInput
            )

            CalculatorInputField(
                title: "y Coefficient",
                symbol: "c",
                unit: "",
                placeholder:
                    "Enter y coefficient",
                text: $yCoefficientInput
            )

            CalculatorInputField(
                title: "xy Coefficient",
                symbol: "d",
                unit: "",
                placeholder:
                    "Enter xy coefficient",
                text: $xyCoefficientInput
            )
        }
    }

    private var initialConditionSection:
        some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            Text("Initial Condition and Interval")
                .font(.headline)

            CalculatorInputField(
                title: "Initial x",
                symbol: "x₀",
                unit: "",
                placeholder:
                    "Enter initial x",
                text: $initialXInput
            )

            CalculatorInputField(
                title: "Initial y",
                symbol: "y₀",
                unit: "",
                placeholder:
                    "Enter initial y",
                text: $initialYInput
            )

            CalculatorInputField(
                title: "Target x",
                symbol: "xₜ",
                unit: "",
                placeholder:
                    "Enter target x",
                text: $targetXInput
            )
        }
    }

    private var numericalSettings: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.medium
        ) {
            Text("Numerical Settings")
                .font(.headline)

            CalculatorInputField(
                title: "Step Size",
                symbol: "h",
                unit: "",
                placeholder:
                    "Example: 0.1",
                text: $stepSizeInput
            )

            CalculatorInputField(
                title: "Maximum Steps",
                symbol: "N",
                unit: "",
                placeholder:
                    "Example: 10000",
                text: $maximumStepsInput
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
        _ result: ODESolverResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Final Independent Variable",
                        value:
                            numberFormatter.format(
                                result.finalX
                            ),
                        unit: "x"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Approximate Solution",
                        value:
                            numberFormatter.format(
                                result.finalY
                            ),
                        unit:
                            "y(\(numberFormatter.format(result.finalX)))"
                    ),
                    CalculationResultDisplayItem(
                        label: "Steps",
                        value:
                            "\(result.stepCount)",
                        unit: ""
                    )
                ]
            )

            if result.adjustedFinalStep {
                CalculatorInfoCard(tint: .blue) {
                    Label(
                        "The final step was shortened so the solution ended exactly at the requested target x value.",
                        systemImage:
                            "info.circle.fill"
                    )
                    .foregroundStyle(.blue)
                }
            }

            solutionChart(result)

            resultInformationCard(result)
        }
    }

    private func solutionChart(
        _ result: ODESolverResult
    ) -> some View {
        Chart(result.points) { point in
            LineMark(
                x: .value("x", point.x),
                y: .value("y", point.y)
            )

            PointMark(
                x: .value("x", point.x),
                y: .value("y", point.y)
            )
            .symbolSize(35)
        }
        .chartXAxisLabel("x")
        .chartYAxisLabel("y")
        .frame(height: 280)
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
        .accessibilityLabel(
            "Numerical solution of y as a function of x"
        )
    }

    private func resultInformationCard(
        _ result: ODESolverResult
    ) -> some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                informationRow(
                    title: "Method",
                    value: result.method.title
                )

                Divider()

                informationRow(
                    title: "Initial Condition",
                    value:
                        "y(\(numberFormatter.format(result.initialX))) = \(numberFormatter.format(result.initialY))"
                )

                informationRow(
                    title: "Requested Target",
                    value:
                        numberFormatter.format(
                            result.targetX
                        )
                )

                informationRow(
                    title: "Nominal Step Size",
                    value:
                        numberFormatter.format(
                            result.stepSize
                        )
                )

                informationRow(
                    title: "Calculated Points",
                    value:
                        "\(result.points.count)"
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

    private func solveEquation() {
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
        -> ODESolverInput {
        let maximumStepsValue =
            try InputValidator.parseNumber(
                maximumStepsInput,
                fieldName: "Maximum Steps"
            )

        guard
            maximumStepsValue.rounded() ==
                maximumStepsValue,
            maximumStepsValue >= 1,
            maximumStepsValue <= 100_000
        else {
            throw CalculationError
                .calculationFailed(
                    reason:
                        "Maximum steps must be an integer between 1 and 100,000."
                )
        }

        return ODESolverInput(
            coefficients:
                ODEEquationCoefficients(
                    constant:
                        try InputValidator
                            .parseNumber(
                                constantInput,
                                fieldName:
                                    "Constant Term"
                            ),
                    xCoefficient:
                        try InputValidator
                            .parseNumber(
                                xCoefficientInput,
                                fieldName:
                                    "x Coefficient"
                            ),
                    yCoefficient:
                        try InputValidator
                            .parseNumber(
                                yCoefficientInput,
                                fieldName:
                                    "y Coefficient"
                            ),
                    xyCoefficient:
                        try InputValidator
                            .parseNumber(
                                xyCoefficientInput,
                                fieldName:
                                    "xy Coefficient"
                            )
                ),
            initialX:
                try InputValidator.parseNumber(
                    initialXInput,
                    fieldName: "Initial x"
                ),
            initialY:
                try InputValidator.parseNumber(
                    initialYInput,
                    fieldName: "Initial y"
                ),
            targetX:
                try InputValidator.parseNumber(
                    targetXInput,
                    fieldName: "Target x"
                ),
            stepSize:
                try InputValidator.parseNumber(
                    stepSizeInput,
                    fieldName: "Step Size"
                ),
            maximumSteps:
                Int(maximumStepsValue)
        )
    }

    private func loadExample() {
        constantInput = "0"
        xCoefficientInput = "0"
        yCoefficientInput = "1"
        xyCoefficientInput = "0"

        initialXInput = "0"
        initialYInput = "1"
        targetXInput = "1"

        stepSizeInput = "0.1"
        maximumStepsInput = "10000"

        clearResult()
    }

    private func resetInputs() {
        constantInput = ""
        xCoefficientInput = ""
        yCoefficientInput = ""
        xyCoefficientInput = ""

        initialXInput = ""
        initialYInput = ""
        targetXInput = ""

        stepSizeInput = "0.1"
        maximumStepsInput = "10000"

        clearResult()
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The differential equation could not be solved."

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
        ODESolverView()
    }
}
