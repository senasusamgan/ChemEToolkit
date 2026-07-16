import SwiftUI

struct CohenCoonTuningView:
    View {

    @State private var processGainInput = "2"
    @State private var timeConstantInput = "10"
    @State private var deadTimeInput = "2"

    @State private var result:
        CohenCoonTuningResult?

    @State private var errorMessage = ""

    private let engine =
        CohenCoonTuningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "waveform.path.ecg",
                    title: "Cohen–Coon Tuning",
                    subtitle: "Calculate open-loop P, PI and PID settings from an FOPDT model",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Cohen–Coon tuning explicitly adjusts its settings according to the process dead-time ratio.")
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
                            systemImage: "waveform.path.ecg",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "P Controller Gain",
                                        value: numberFormatter.format(result.proportionalGain),
                                        unit: "controller gain"
                                    ),
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
                                        label: "Dead-Time Ratio",
                                        value: numberFormatter.format(result.deadTimeRatio),
                                        unit: "θ/τ"
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
        .navigationTitle("Cohen–Coon Tuning")
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
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        processGainInput = ""
        timeConstantInput = ""
        deadTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CohenCoonTuningView()
    }
}
