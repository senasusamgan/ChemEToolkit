import SwiftUI

struct ModelPredictiveControlView: View {
    @State private var currentOutputInput = "20"
    @State private var setpointInput = "30"
    @State private var processGainInput = "2"
    @State private var timeConstantInput = "5"
    @State private var sampleTimeInput = "1"
    @State private var horizonInput = "8"
    @State private var moveWeightInput = "1"
    @State private var previousInput = "10"
    @State private var minimumInput = "0"
    @State private var maximumInput = "100"

    @State private var result: ModelPredictiveControlResult?
    @State private var errorMessage = ""

    private let engine = ModelPredictiveControlEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.grid.3x3",
                    title: "Model Predictive Control",
                    subtitle: "Optimize one constrained input move over a finite prediction horizon",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The move-suppression weight balances reference tracking against aggressive manipulated-input changes.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Current Process Output",
                            symbol: "y₀",
                            unit: "output units",
                            placeholder: "20",
                            text: $currentOutputInput
                        )

                        EngineeringInputField(
                            title: "Reference Setpoint",
                            symbol: "r",
                            unit: "output units",
                            placeholder: "30",
                            text: $setpointInput
                        )

                        EngineeringInputField(
                            title: "Process Gain",
                            symbol: "K",
                            unit: "output/input",
                            placeholder: "2",
                            text: $processGainInput
                        )

                        EngineeringInputField(
                            title: "Process Time Constant",
                            symbol: "τ",
                            unit: "time",
                            placeholder: "5",
                            text: $timeConstantInput
                        )

                        EngineeringInputField(
                            title: "Sample Time",
                            symbol: "Δt",
                            unit: "time",
                            placeholder: "1",
                            text: $sampleTimeInput
                        )

                        EngineeringInputField(
                            title: "Prediction Horizon",
                            symbol: "Nₚ",
                            unit: "steps",
                            placeholder: "8",
                            text: $horizonInput
                        )

                        EngineeringInputField(
                            title: "Move-Suppression Weight",
                            symbol: "λᵤ",
                            unit: "—",
                            placeholder: "1",
                            text: $moveWeightInput
                        )

                        EngineeringInputField(
                            title: "Previous Manipulated Input",
                            symbol: "u_prev",
                            unit: "input units",
                            placeholder: "10",
                            text: $previousInput
                        )

                        EngineeringInputField(
                            title: "Minimum Manipulated Input",
                            symbol: "u_min",
                            unit: "input units",
                            placeholder: "0",
                            text: $minimumInput
                        )

                        EngineeringInputField(
                            title: "Maximum Manipulated Input",
                            symbol: "u_max",
                            unit: "input units",
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
                            systemImage: "square.grid.3x3",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Applied Input Move",
                                        value: numberFormatter.format(result.appliedInputMove),
                                        unit: "input units"
                                    ),
.init(
                                        label: "Applied Manipulated Input",
                                        value: numberFormatter.format(result.appliedManipulatedInput),
                                        unit: "input units"
                                    ),
.init(
                                        label: "First Predicted Output",
                                        value: numberFormatter.format(result.predictedFirstStepOutput),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Horizon Predicted Output",
                                        value: numberFormatter.format(result.predictedHorizonOutput),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Horizon Tracking Error",
                                        value: numberFormatter.format(result.predictedHorizonError),
                                        unit: "output units"
                                    ),
.init(
                                        label: "Input Constraint Active",
                                        value: result.inputConstraintIsActive ? "Yes" : "No",
                                        unit: "—"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
                                    Divider()
                                    Text(result.limitationDescription).foregroundStyle(.secondary)
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
        .navigationTitle("Model Predictive Control")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    currentProcessOutput: try InputValidator.parseNumber(currentOutputInput, fieldName: "current process output"),
                    referenceSetpoint: try InputValidator.parseNumber(setpointInput, fieldName: "reference setpoint"),
                    processGain: try InputValidator.parseNumber(processGainInput, fieldName: "process gain"),
                    processTimeConstant: try InputValidator.parseNumber(timeConstantInput, fieldName: "process time constant"),
                    sampleTime: try InputValidator.parseNumber(sampleTimeInput, fieldName: "sample time"),
                    predictionHorizonSteps: try InputValidator.parseNumber(horizonInput, fieldName: "prediction horizon"),
                    moveSuppressionWeight: try InputValidator.parseNumber(moveWeightInput, fieldName: "move-suppression weight"),
                    previousManipulatedInput: try InputValidator.parseNumber(previousInput, fieldName: "previous manipulated input"),
                    minimumManipulatedInput: try InputValidator.parseNumber(minimumInput, fieldName: "minimum manipulated input"),
                    maximumManipulatedInput: try InputValidator.parseNumber(maximumInput, fieldName: "maximum manipulated input")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        currentOutputInput = "20"
        setpointInput = "30"
        processGainInput = "2"
        timeConstantInput = "5"
        sampleTimeInput = "1"
        horizonInput = "8"
        moveWeightInput = "1"
        previousInput = "10"
        minimumInput = "0"
        maximumInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        currentOutputInput = ""
        setpointInput = ""
        processGainInput = ""
        timeConstantInput = ""
        sampleTimeInput = ""
        horizonInput = ""
        moveWeightInput = ""
        previousInput = ""
        minimumInput = ""
        maximumInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { ModelPredictiveControlView() } }
