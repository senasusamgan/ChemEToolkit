import SwiftUI

struct TransferFunctionBuilderView: View {
    @State private var b1Input = "1"
    @State private var b0Input = "2"
    @State private var a2Input = "1"
    @State private var a1Input = "3"
    @State private var a0Input = "2"
    @State private var frequencyInput = "1"

    @State private var result: TransferFunctionBuilderResult?
    @State private var errorMessage = ""

    private let engine = TransferFunctionBuilderEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "waveform.path",
                    title: "Transfer Function Builder",
                    subtitle: "Build and evaluate a low-order SISO transfer function",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The module supports a linear numerator and a denominator up to second order.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Numerator Linear Coefficient",
                            symbol: "b₁",
                            unit: "—",
                            placeholder: "1",
                            text: $b1Input
                        )

                        EngineeringInputField(
                            title: "Numerator Constant",
                            symbol: "b₀",
                            unit: "—",
                            placeholder: "2",
                            text: $b0Input
                        )

                        EngineeringInputField(
                            title: "Denominator Quadratic Coefficient",
                            symbol: "a₂",
                            unit: "—",
                            placeholder: "1",
                            text: $a2Input
                        )

                        EngineeringInputField(
                            title: "Denominator Linear Coefficient",
                            symbol: "a₁",
                            unit: "—",
                            placeholder: "3",
                            text: $a1Input
                        )

                        EngineeringInputField(
                            title: "Denominator Constant",
                            symbol: "a₀",
                            unit: "—",
                            placeholder: "2",
                            text: $a0Input
                        )

                        EngineeringInputField(
                            title: "Angular Frequency",
                            symbol: "ω",
                            unit: "rad/time",
                            placeholder: "1",
                            text: $frequencyInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label("Load Example", systemImage: "arrow.counterclockwise")
                            }
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "waveform.path",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Transfer Function",
                                        value: result.transferFunctionExpression,
                                        unit: "—"
                                    ),
.init(
                                        label: "Properness",
                                        value: result.propernessDescription,
                                        unit: "—"
                                    ),
.init(
                                        label: "Magnitude",
                                        value: numberFormatter.format(result.magnitude),
                                        unit: "—"
                                    ),
.init(
                                        label: "Phase",
                                        value: numberFormatter.format(result.phaseDegrees),
                                        unit: "degrees"
                                    ),
.init(
                                        label: "DC Gain",
                                        value: result.dcGain.map { numberFormatter.format($0) } ?? "Undefined",
                                        unit: "—"
                                    ),
.init(
                                        label: "Denominator Stability",
                                        value: result.stabilityDescription,
                                        unit: "—"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
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
        .navigationTitle("Transfer Function Builder")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    numeratorLinearCoefficient: try InputValidator.parseNumber(
                        b1Input,
                        fieldName: "numerator linear coefficient"
                    ),
                    numeratorConstant: try InputValidator.parseNumber(
                        b0Input,
                        fieldName: "numerator constant"
                    ),
                    denominatorQuadraticCoefficient: try InputValidator.parseNumber(
                        a2Input,
                        fieldName: "denominator quadratic coefficient"
                    ),
                    denominatorLinearCoefficient: try InputValidator.parseNumber(
                        a1Input,
                        fieldName: "denominator linear coefficient"
                    ),
                    denominatorConstant: try InputValidator.parseNumber(
                        a0Input,
                        fieldName: "denominator constant"
                    ),
                    angularFrequency: try InputValidator.parseNumber(
                        frequencyInput,
                        fieldName: "angular frequency"
                    )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        b1Input = "1"
        b0Input = "2"
        a2Input = "1"
        a1Input = "3"
        a0Input = "2"
        frequencyInput = "1"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        b1Input = ""
        b0Input = ""
        a2Input = ""
        a1Input = ""
        a0Input = ""
        frequencyInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { TransferFunctionBuilderView() }
}
