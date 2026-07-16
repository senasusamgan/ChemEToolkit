import SwiftUI

struct ProportionalControllerView: View {
    @State private var biasInput = "50"
    @State private var gainInput = "2"
    @State private var errorInput = "10"
    @State private var minInput = "0"
    @State private var maxInput = "100"
    @State private var result: ProportionalControllerResult?
    @State private var errorMessage = ""

    private let engine = ProportionalControllerEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "slider.horizontal.3",
                    title: "Proportional Controller",
                    subtitle: "Calculate proportional action, bias and output saturation",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Output is limited to the selected actuator range after proportional action is added to the bias.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Controller Bias",
                            symbol: "u_bias",
                            unit: "%",
                            placeholder: "50",
                            text: $biasInput
                        )

                        EngineeringInputField(
                            title: "Controller Gain",
                            symbol: "K_c",
                            unit: "%/error",
                            placeholder: "2",
                            text: $gainInput
                        )

                        EngineeringInputField(
                            title: "Current Error",
                            symbol: "e",
                            unit: "error units",
                            placeholder: "10",
                            text: $errorInput
                        )

                        EngineeringInputField(
                            title: "Minimum Output",
                            symbol: "u_min",
                            unit: "%",
                            placeholder: "0",
                            text: $minInput
                        )

                        EngineeringInputField(
                            title: "Maximum Output",
                            symbol: "u_max",
                            unit: "%",
                            placeholder: "100",
                            text: $maxInput
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
                            title: "Calculate Controller Output",
                            systemImage: "slider.horizontal.3",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Proportional Contribution", value: formatter.format(result.proportionalContribution), unit: "%"),
.init(label: "Unconstrained Output", value: formatter.format(result.unconstrainedOutput), unit: "%"),
.init(label: "Constrained Output", value: formatter.format(result.constrainedOutput), unit: "%"),
.init(label: "Saturation Amount", value: formatter.format(result.saturationAmount), unit: "%"),
.init(label: "Low Saturation", value: result.isSaturatedLow ? "Yes" : "No", unit: "—"),
.init(label: "High Saturation", value: result.isSaturatedHigh ? "Yes" : "No", unit: "—")
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
        .navigationTitle("Proportional Controller")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    controllerBias: try InputValidator.parseNumber(biasInput, fieldName: "controller bias"),
                    controllerGain: try InputValidator.parseNumber(gainInput, fieldName: "controller gain"),
                    currentError: try InputValidator.parseNumber(errorInput, fieldName: "current error"),
                    minimumOutput: try InputValidator.parseNumber(minInput, fieldName: "minimum output"),
                    maximumOutput: try InputValidator.parseNumber(maxInput, fieldName: "maximum output")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        biasInput = "50"
        gainInput = "2"
        errorInput = "10"
        minInput = "0"
        maxInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        biasInput = ""
        gainInput = ""
        errorInput = ""
        minInput = ""
        maxInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { ProportionalControllerView() }
}
