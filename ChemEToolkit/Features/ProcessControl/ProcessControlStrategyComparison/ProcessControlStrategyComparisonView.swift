import SwiftUI

struct ProcessControlStrategyComparisonView: View {
    @State private var deadTimeRatioInput = "0.4"
    @State private var disturbanceInput = "0.7"
    @State private var secondaryInput = "0.8"
    @State private var interactionInput = "0.3"
    @State private var modelConfidenceInput = "0.8"
    @State private var nonlinearityInput = "0.2"

    @State private var result: ProcessControlStrategyComparisonResult?
    @State private var errorMessage = ""

    private let engine = ProcessControlStrategyComparisonEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "list.bullet.rectangle",
                    title: "Control Strategy Comparison",
                    subtitle: "Screen PID, feedforward, cascade and MPC options",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Use the scores as an initial screening aid, then validate the leading strategies with process-specific dynamic studies.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Dead-Time Ratio",
                            symbol: "θ/τ",
                            unit: "—",
                            placeholder: "0.4",
                            text: $deadTimeRatioInput
                        )

                        EngineeringInputField(
                            title: "Measurable Disturbance Fraction",
                            symbol: "D_m",
                            unit: "0–1",
                            placeholder: "0.7",
                            text: $disturbanceInput
                        )

                        EngineeringInputField(
                            title: "Secondary Measurement Quality",
                            symbol: "Q_s",
                            unit: "0–1",
                            placeholder: "0.8",
                            text: $secondaryInput
                        )

                        EngineeringInputField(
                            title: "Process Interaction Level",
                            symbol: "I",
                            unit: "0–1",
                            placeholder: "0.3",
                            text: $interactionInput
                        )

                        EngineeringInputField(
                            title: "Process Model Confidence",
                            symbol: "C_m",
                            unit: "0–1",
                            placeholder: "0.8",
                            text: $modelConfidenceInput
                        )

                        EngineeringInputField(
                            title: "Operating Nonlinearity",
                            symbol: "N",
                            unit: "0–1",
                            placeholder: "0.2",
                            text: $nonlinearityInput
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
                            systemImage: "list.bullet.rectangle",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Recommended Strategy",
                                        value: result.recommendedStrategy,
                                        unit: "—"
                                    ),
.init(
                                        label: "Second Choice",
                                        value: result.secondChoiceStrategy,
                                        unit: "—"
                                    ),
.init(
                                        label: "PID Score",
                                        value: numberFormatter.format(result.pidScore),
                                        unit: "/100"
                                    ),
.init(
                                        label: "Feedforward Score",
                                        value: numberFormatter.format(result.feedforwardScore),
                                        unit: "/100"
                                    ),
.init(
                                        label: "Cascade Score",
                                        value: numberFormatter.format(result.cascadeScore),
                                        unit: "/100"
                                    ),
.init(
                                        label: "MPC Score",
                                        value: numberFormatter.format(result.mpcScore),
                                        unit: "/100"
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
        .navigationTitle("Control Strategy Comparison")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    deadTimeToTimeConstantRatio: try InputValidator.parseNumber(deadTimeRatioInput, fieldName: "dead-time ratio"),
                    measurableDisturbanceFraction: try InputValidator.parseNumber(disturbanceInput, fieldName: "measurable disturbance fraction"),
                    secondaryMeasurementQuality: try InputValidator.parseNumber(secondaryInput, fieldName: "secondary measurement quality"),
                    processInteractionLevel: try InputValidator.parseNumber(interactionInput, fieldName: "process interaction level"),
                    processModelConfidence: try InputValidator.parseNumber(modelConfidenceInput, fieldName: "process model confidence"),
                    operatingNonlinearity: try InputValidator.parseNumber(nonlinearityInput, fieldName: "operating nonlinearity")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        deadTimeRatioInput = "0.4"
        disturbanceInput = "0.7"
        secondaryInput = "0.8"
        interactionInput = "0.3"
        modelConfidenceInput = "0.8"
        nonlinearityInput = "0.2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        deadTimeRatioInput = ""
        disturbanceInput = ""
        secondaryInput = ""
        interactionInput = ""
        modelConfidenceInput = ""
        nonlinearityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { ProcessControlStrategyComparisonView() } }
