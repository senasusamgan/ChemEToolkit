import SwiftUI

    struct PowerMethodEigenvalueView: View {
        @State private var a11Input = "4"
    @State private var a12Input = "1"
    @State private var a21Input = "1"
    @State private var a22Input = "2"
    @State private var xInput = "1"
    @State private var yInput = "1"
    @State private var toleranceInput = "0.00000001"
    @State private var iterationsInput = "500"

        @State private var result: PowerMethodEigenvalueResult?
        @State private var errorMessage = ""

        private let engine = PowerMethodEigenvalueEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "matrix.fill",
                        title: "Power Method Eigenvalue",
                        subtitle: "Estimate the dominant eigenvalue of a 2×2 matrix",
                        tint: .indigo
                    )

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "Matrix a11",
                        symbol: "a11",
                        unit: "—",
                        placeholder: "4",
                        text: $a11Input
                    )

                    EngineeringInputField(
                        title: "Matrix a12",
                        symbol: "a12",
                        unit: "—",
                        placeholder: "1",
                        text: $a12Input
                    )

                    EngineeringInputField(
                        title: "Matrix a21",
                        symbol: "a21",
                        unit: "—",
                        placeholder: "1",
                        text: $a21Input
                    )

                    EngineeringInputField(
                        title: "Matrix a22",
                        symbol: "a22",
                        unit: "—",
                        placeholder: "2",
                        text: $a22Input
                    )

                    EngineeringInputField(
                        title: "Initial X",
                        symbol: "x0",
                        unit: "—",
                        placeholder: "1",
                        text: $xInput
                    )

                    EngineeringInputField(
                        title: "Initial Y",
                        symbol: "y0",
                        unit: "—",
                        placeholder: "1",
                        text: $yInput
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
                        placeholder: "500",
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
                                systemImage: "matrix.fill",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Dominant Eigenvalue",
                                value: numberFormatter.format(result.dominantEigenvalue),
                                unit: "—"
                            ),
.init(
                                label: "Eigenvector X",
                                value: numberFormatter.format(result.eigenvectorX),
                                unit: "—"
                            ),
.init(
                                label: "Eigenvector Y",
                                value: numberFormatter.format(result.eigenvectorY),
                                unit: "—"
                            ),
.init(
                                label: "Residual Norm",
                                value: numberFormatter.format(result.residualNorm),
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
            .navigationTitle("Power Method Eigenvalue")
        }

        private func calculate() {
            result = nil
            errorMessage = ""
            do {
                result = try engine.calculate(
                    .init(
                            a11: try InputValidator.parseNumber(
                            a11Input,
                            fieldName: "matrix a11"
                        ),
                        a12: try InputValidator.parseNumber(
                            a12Input,
                            fieldName: "matrix a12"
                        ),
                        a21: try InputValidator.parseNumber(
                            a21Input,
                            fieldName: "matrix a21"
                        ),
                        a22: try InputValidator.parseNumber(
                            a22Input,
                            fieldName: "matrix a22"
                        ),
                        initialX: try InputValidator.parseNumber(
                            xInput,
                            fieldName: "initial x"
                        ),
                        initialY: try InputValidator.parseNumber(
                            yInput,
                            fieldName: "initial y"
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
            a11Input = ""
        a12Input = ""
        a21Input = ""
        a22Input = ""
        xInput = ""
        yInput = ""
        toleranceInput = ""
        iterationsInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { PowerMethodEigenvalueView() }
    }
