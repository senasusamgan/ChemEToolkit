import SwiftUI

struct PDControllerView: View {
    @State private var biasInput = "50"
    @State private var gainInput = "2"
    @State private var errorInput = "4"
    @State private var rateInput = "-1.5"
    @State private var tdInput = "3"
    @State private var minInput = "0"
    @State private var maxInput = "100"
    @State private var result: PDControllerResult?
    @State private var errorMessage = ""

    private let engine = PDControllerEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "speedometer",
                    title: "PD Controller",
                    subtitle: "Calculate proportional and derivative controller action",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Derivative action responds to the rate of error change and can add damping, but it is sensitive to measurement noise.")
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
                            placeholder: "4",
                            text: $errorInput
                        )

                        EngineeringInputField(
                            title: "Error Rate of Change",
                            symbol: "de/dt",
                            unit: "error/time",
                            placeholder: "-1.5",
                            text: $rateInput
                        )

                        EngineeringInputField(
                            title: "Derivative Time",
                            symbol: "T_d",
                            unit: "time",
                            placeholder: "3",
                            text: $tdInput
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
                            systemImage: "speedometer",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Proportional Contribution", value: formatter.format(result.proportionalContribution), unit: "%"),
.init(label: "Derivative Contribution", value: formatter.format(result.derivativeContribution), unit: "%"),
.init(label: "Unconstrained Output", value: formatter.format(result.unconstrainedOutput), unit: "%"),
.init(label: "Constrained Output", value: formatter.format(result.constrainedOutput), unit: "%"),
.init(label: "Equivalent Derivative Gain", value: formatter.format(result.equivalentDerivativeGain), unit: "time"),
.init(label: "Low Saturation", value: result.isSaturatedLow ? "Yes" : "No", unit: "—")
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
        .navigationTitle("PD Controller")
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
                    errorRateOfChange: try InputValidator.parseNumber(rateInput, fieldName: "error rate of change"),
                    derivativeTime: try InputValidator.parseNumber(tdInput, fieldName: "derivative time"),
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
        errorInput = "4"
        rateInput = "-1.5"
        tdInput = "3"
        minInput = "0"
        maxInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        biasInput = ""
        gainInput = ""
        errorInput = ""
        rateInput = ""
        tdInput = ""
        minInput = ""
        maxInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { PDControllerView() }
}
