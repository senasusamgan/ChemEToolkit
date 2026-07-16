import SwiftUI

struct PIDControllerView: View {
    @State private var biasInput = "40"
    @State private var gainInput = "2"
    @State private var errorInput = "5"
    @State private var integralInput = "12"
    @State private var rateInput = "-1"
    @State private var tiInput = "4"
    @State private var tdInput = "2"
    @State private var minInput = "0"
    @State private var maxInput = "100"
    @State private var result: PIDControllerResult?
    @State private var errorMessage = ""

    private let engine = PIDControllerEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "dial.high.fill",
                    title: "PID Controller",
                    subtitle: "Calculate proportional, integral and derivative controller action",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("PID combines present error, accumulated past error and the current rate of error change.")
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
                            placeholder: "40",
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
                            placeholder: "5",
                            text: $errorInput
                        )

                        EngineeringInputField(
                            title: "Accumulated Error Integral",
                            symbol: "∫e dt",
                            unit: "error·time",
                            placeholder: "12",
                            text: $integralInput
                        )

                        EngineeringInputField(
                            title: "Error Rate of Change",
                            symbol: "de/dt",
                            unit: "error/time",
                            placeholder: "-1",
                            text: $rateInput
                        )

                        EngineeringInputField(
                            title: "Integral Time",
                            symbol: "T_i",
                            unit: "time",
                            placeholder: "4",
                            text: $tiInput
                        )

                        EngineeringInputField(
                            title: "Derivative Time",
                            symbol: "T_d",
                            unit: "time",
                            placeholder: "2",
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
                            systemImage: "dial.high.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Proportional Contribution", value: formatter.format(result.proportionalContribution), unit: "%"),
.init(label: "Integral Contribution", value: formatter.format(result.integralContribution), unit: "%"),
.init(label: "Derivative Contribution", value: formatter.format(result.derivativeContribution), unit: "%"),
.init(label: "Unconstrained Output", value: formatter.format(result.unconstrainedOutput), unit: "%"),
.init(label: "Constrained Output", value: formatter.format(result.constrainedOutput), unit: "%"),
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
        .navigationTitle("PID Controller")
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
                    accumulatedErrorIntegral: try InputValidator.parseNumber(integralInput, fieldName: "accumulated error integral"),
                    errorRateOfChange: try InputValidator.parseNumber(rateInput, fieldName: "error rate of change"),
                    integralTime: try InputValidator.parseNumber(tiInput, fieldName: "integral time"),
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
        biasInput = "40"
        gainInput = "2"
        errorInput = "5"
        integralInput = "12"
        rateInput = "-1"
        tiInput = "4"
        tdInput = "2"
        minInput = "0"
        maxInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        biasInput = ""
        gainInput = ""
        errorInput = ""
        integralInput = ""
        rateInput = ""
        tiInput = ""
        tdInput = ""
        minInput = ""
        maxInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { PIDControllerView() }
}
