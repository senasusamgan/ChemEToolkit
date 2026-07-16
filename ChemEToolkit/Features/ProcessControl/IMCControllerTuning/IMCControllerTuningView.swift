import SwiftUI

struct IMCControllerTuningView:
    View {

    @State private var processGainInput = "2"
    @State private var timeConstantInput = "10"
    @State private var deadTimeInput = "2"
    @State private var lambdaInput = "4"

    @State private var result:
        IMCControllerTuningResult?

    @State private var errorMessage = ""

    private let engine =
        IMCControllerTuningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "gearshape.fill",
                    title: "IMC Controller Tuning",
                    subtitle: "Tune robust PI and PID controllers using the desired closed-loop time λ",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Increasing λ produces slower but more robust and smoother controller behavior.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout
                            .calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
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
                            placeholder: "10",
                            text: $timeConstantInput
                        )

                        EngineeringInputField(
                            title: "Process Dead Time",
                            symbol: "θ",
                            unit: "time",
                            placeholder: "2",
                            text: $deadTimeInput
                        )

                        EngineeringInputField(
                            title: "Desired Closed-Loop Time",
                            symbol: "λ",
                            unit: "time",
                            placeholder: "4",
                            text: $lambdaInput
                        )

                        HStack(
                            spacing: AppSpacing.medium
                        ) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage:
                                        "arrow.counterclockwise"
                                )
                            }

                            Spacer()

                            Button(
                                role: .destructive,
                                action: resetInputs
                            ) {
                                Label(
                                    "Clear",
                                    systemImage: "trash"
                                )
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title:
                                "Calculate Tuning",
                            systemImage: "gearshape.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "PI Controller Gain",
                                        value: numberFormatter.format(result.piGain),
                                        unit: "controller gain"
                                    ),
.init(
                                        label: "PI Integral Time",
                                        value: numberFormatter.format(result.piIntegralTime),
                                        unit: "time"
                                    ),
.init(
                                        label: "PID Controller Gain",
                                        value: numberFormatter.format(result.pidGain),
                                        unit: "controller gain"
                                    ),
.init(
                                        label: "PID Integral Time",
                                        value: numberFormatter.format(result.pidIntegralTime),
                                        unit: "time"
                                    ),
.init(
                                        label: "PID Derivative Time",
                                        value: numberFormatter.format(result.pidDerivativeTime),
                                        unit: "time"
                                    ),
.init(
                                        label: "λ / Dead-Time Ratio",
                                        value: result.lambdaToDeadTimeRatio.isFinite ? numberFormatter.format(result.lambdaToDeadTimeRatio) : "No dead time",
                                        unit: "—"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(
                                    alignment: .leading,
                                    spacing: AppSpacing.small
                                ) {
                                    Text(result.modelName)
                                        .font(.headline)

                                    Divider()

                                    Text(
                                        result
                                            .limitationDescription
                                    )
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(
                                message: errorMessage
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
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
        .navigationTitle("IMC Controller Tuning")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    processGain:
                        try InputValidator.parseNumber(
                            processGainInput,
                            fieldName:
                                "process gain"
                        ),
                    processTimeConstant:
                        try InputValidator.parseNumber(
                            timeConstantInput,
                            fieldName:
                                "process time constant"
                        ),
                    processDeadTime:
                        try InputValidator.parseNumber(
                            deadTimeInput,
                            fieldName:
                                "process dead time"
                        ),
                    closedLoopTimeConstant:
                        try InputValidator.parseNumber(
                            lambdaInput,
                            fieldName:
                                "desired closed-loop time constant"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        processGainInput = "2"
        timeConstantInput = "10"
        deadTimeInput = "2"
        lambdaInput = "4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        processGainInput = ""
        timeConstantInput = ""
        deadTimeInput = ""
        lambdaInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        IMCControllerTuningView()
    }
}
