import SwiftUI

    struct GaussNewtonNonlinearRegressionView: View {
        @State private var x1Input = "0"
    @State private var y1Input = "2"
    @State private var x2Input = "1"
    @State private var y2Input = "3.29744254"
    @State private var x3Input = "2"
    @State private var y3Input = "5.43656366"
    @State private var aInput = "1.5"
    @State private var bInput = "0.4"
    @State private var toleranceInput = "0.00000001"
    @State private var iterationsInput = "100"

        @State private var result: GaussNewtonNonlinearRegressionResult?
        @State private var errorMessage = ""

        private let engine = GaussNewtonNonlinearRegressionEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "chart.xyaxis.line",
                        title: "Gauss–Newton Nonlinear Regression",
                        subtitle: "Fit y = a·exp(bx) to three observations",
                        tint: .indigo
                    )

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "x1",
                        symbol: "x1",
                        unit: "—",
                        placeholder: "0",
                        text: $x1Input
                    )

                    EngineeringInputField(
                        title: "y1",
                        symbol: "y1",
                        unit: "—",
                        placeholder: "2",
                        text: $y1Input
                    )

                    EngineeringInputField(
                        title: "x2",
                        symbol: "x2",
                        unit: "—",
                        placeholder: "1",
                        text: $x2Input
                    )

                    EngineeringInputField(
                        title: "y2",
                        symbol: "y2",
                        unit: "—",
                        placeholder: "3.29744254",
                        text: $y2Input
                    )

                    EngineeringInputField(
                        title: "x3",
                        symbol: "x3",
                        unit: "—",
                        placeholder: "2",
                        text: $x3Input
                    )

                    EngineeringInputField(
                        title: "y3",
                        symbol: "y3",
                        unit: "—",
                        placeholder: "5.43656366",
                        text: $y3Input
                    )

                    EngineeringInputField(
                        title: "Initial A",
                        symbol: "a0",
                        unit: "—",
                        placeholder: "1.5",
                        text: $aInput
                    )

                    EngineeringInputField(
                        title: "Initial B",
                        symbol: "b0",
                        unit: "—",
                        placeholder: "0.4",
                        text: $bInput
                    )

                    EngineeringInputField(
                        title: "Tolerance",
                        symbol: "epsilon",
                        unit: "—",
                        placeholder: "0.00000001",
                        text: $toleranceInput
                    )

                    EngineeringInputField(
                        title: "Maximum Iterations",
                        symbol: "N",
                        unit: "iterations",
                        placeholder: "100",
                        text: $iterationsInput
                    )

                            HStack {
                                Spacer()
                                Button(role: .destructive, action: resetInputs) {
                                    Label("Clear", systemImage: "trash")
                                }
                            }
                            .buttonStyle(.bordered)

                            PrimaryActionButton(
                                title: "Calculate",
                                systemImage: "chart.xyaxis.line",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Parameter A",
                                value: numberFormatter.format(result.parameterA),
                                unit: "—"
                            ),
.init(
                                label: "Parameter B",
                                value: numberFormatter.format(result.parameterB),
                                unit: "—"
                            ),
.init(
                                label: "Sum-Squared Error",
                                value: numberFormatter.format(result.sumSquaredError),
                                unit: "—"
                            ),
.init(
                                label: "RMSE",
                                value: numberFormatter.format(result.rootMeanSquaredError),
                                unit: "—"
                            ),
.init(
                                label: "Iterations",
                                value: numberFormatter.format(result.iterationCount),
                                unit: "iterations"
                            )
                                    ],
                                    tint: .indigo
                                )

                                CalculatorInfoCard(tint: .indigo) {
                                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                                        Text(result.modelName).font(.headline)
                                        Divider()
                                        Text(result.limitationDescription)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }

                            if !errorMessage.isEmpty {
                                CalculationErrorCard(message: errorMessage)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
                .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
            }
            .navigationTitle("Gauss–Newton Nonlinear Regression")
        }

        private func calculate() {
            result = nil
            errorMessage = ""
            do {
                result = try engine.calculate(
                    .init(
                            x1: try InputValidator.parseNumber(
                            x1Input,
                            fieldName: "x1"
                        ),
                        y1: try InputValidator.parseNumber(
                            y1Input,
                            fieldName: "y1"
                        ),
                        x2: try InputValidator.parseNumber(
                            x2Input,
                            fieldName: "x2"
                        ),
                        y2: try InputValidator.parseNumber(
                            y2Input,
                            fieldName: "y2"
                        ),
                        x3: try InputValidator.parseNumber(
                            x3Input,
                            fieldName: "x3"
                        ),
                        y3: try InputValidator.parseNumber(
                            y3Input,
                            fieldName: "y3"
                        ),
                        initialA: try InputValidator.parseNumber(
                            aInput,
                            fieldName: "initial a"
                        ),
                        initialB: try InputValidator.parseNumber(
                            bInput,
                            fieldName: "initial b"
                        ),
                        tolerance: try InputValidator.parseNumber(
                            toleranceInput,
                            fieldName: "tolerance"
                        ),
                        maximumIterations: try InputValidator.parseNumber(
                            iterationsInput,
                            fieldName: "maximum iterations"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            x1Input = ""
        y1Input = ""
        x2Input = ""
        y2Input = ""
        x3Input = ""
        y3Input = ""
        aInput = ""
        bInput = ""
        toleranceInput = ""
        iterationsInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { GaussNewtonNonlinearRegressionView() }
    }
