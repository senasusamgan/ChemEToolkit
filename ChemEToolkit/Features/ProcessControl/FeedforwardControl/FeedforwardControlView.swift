import SwiftUI

struct FeedforwardControlView: View {
    @State private var manipulatedGainInput = "2"
    @State private var disturbanceGainInput = "5"
    @State private var disturbanceInput = "4"
    @State private var biasInput = "50"
    @State private var minimumInput = "0"
    @State private var maximumInput = "100"

    @State private var result: FeedforwardControlResult?
    @State private var errorMessage = ""

    private let engine = FeedforwardControlEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.branch",
                    title: "Feedforward Control",
                    subtitle: "Calculate steady-state disturbance compensation and actuator limitation",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Feedforward control acts on a measured disturbance before the process output deviates.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Manipulated-Path Gain",
                            symbol: "K_u",
                            unit: "output/input",
                            placeholder: "2",
                            text: $manipulatedGainInput
                        )

                        EngineeringInputField(
                            title: "Disturbance-Path Gain",
                            symbol: "K_d",
                            unit: "output/disturbance",
                            placeholder: "5",
                            text: $disturbanceGainInput
                        )

                        EngineeringInputField(
                            title: "Measured Disturbance Change",
                            symbol: "Δd",
                            unit: "disturbance units",
                            placeholder: "4",
                            text: $disturbanceInput
                        )

                        EngineeringInputField(
                            title: "Controller Bias",
                            symbol: "u_bias",
                            unit: "%",
                            placeholder: "50",
                            text: $biasInput
                        )

                        EngineeringInputField(
                            title: "Minimum Controller Output",
                            symbol: "u_min",
                            unit: "%",
                            placeholder: "0",
                            text: $minimumInput
                        )

                        EngineeringInputField(
                            title: "Maximum Controller Output",
                            symbol: "u_max",
                            unit: "%",
                            placeholder: "100",
                            text: $maximumInput
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
                            systemImage: "arrow.triangle.branch",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Ideal Manipulated Change",
                                        value: numberFormatter.format(result.idealManipulatedVariableChange),
                                        unit: "input units"
                                    ),
.init(
                                        label: "Applied Controller Output",
                                        value: numberFormatter.format(result.appliedControllerOutput),
                                        unit: "%"
                                    ),
.init(
                                        label: "Uncompensated Output Change",
                                        value: numberFormatter.format(result.uncompensatedOutputChange),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Residual Output Change",
                                        value: numberFormatter.format(result.residualOutputChange),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Disturbance Cancellation",
                                        value: numberFormatter.format(100 * result.cancellationFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Controller Saturated",
                                        value: result.controllerIsSaturated ? "Yes" : "No",
                                        unit: "—"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName)
                                        .font(.headline)

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
        .navigationTitle("Feedforward Control")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    manipulatedPathGain: try InputValidator.parseNumber(
                        manipulatedGainInput,
                        fieldName: "manipulated-path gain"
                    ),
                    disturbancePathGain: try InputValidator.parseNumber(
                        disturbanceGainInput,
                        fieldName: "disturbance-path gain"
                    ),
                    measuredDisturbanceChange: try InputValidator.parseNumber(
                        disturbanceInput,
                        fieldName: "measured disturbance change"
                    ),
                    controllerBias: try InputValidator.parseNumber(
                        biasInput,
                        fieldName: "controller bias"
                    ),
                    minimumControllerOutput: try InputValidator.parseNumber(
                        minimumInput,
                        fieldName: "minimum controller output"
                    ),
                    maximumControllerOutput: try InputValidator.parseNumber(
                        maximumInput,
                        fieldName: "maximum controller output"
                    )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        manipulatedGainInput = "2"
        disturbanceGainInput = "5"
        disturbanceInput = "4"
        biasInput = "50"
        minimumInput = "0"
        maximumInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        manipulatedGainInput = ""
        disturbanceGainInput = ""
        disturbanceInput = ""
        biasInput = ""
        minimumInput = ""
        maximumInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FeedforwardControlView()
    }
}
