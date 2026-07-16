import SwiftUI

struct ZieglerNicholsUltimateGainTuningView:
    View {

    @State private var ultimateGainInput = "8"
    @State private var ultimatePeriodInput = "6"

    @State private var result:
        ZieglerNicholsUltimateGainTuningResult?

    @State private var errorMessage = ""

    private let engine =
        ZieglerNicholsUltimateGainTuningEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "slider.horizontal.3",
                    title: "Ziegler–Nichols Ultimate Gain",
                    subtitle: "Generate classic P, PI and PID settings from Kᵤ and Pᵤ",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The ultimate-gain method uses the gain and period of sustained closed-loop oscillation.")
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
                            title: "Ultimate Gain",
                            symbol: "K_u",
                            unit: "controller gain",
                            placeholder: "8",
                            text: $ultimateGainInput
                        )

                        EngineeringInputField(
                            title: "Ultimate Period",
                            symbol: "P_u",
                            unit: "time",
                            placeholder: "6",
                            text: $ultimatePeriodInput
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
                            systemImage: "slider.horizontal.3",
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
                                        label: "Ultimate Frequency",
                                        value: numberFormatter.format(result.ultimateFrequency),
                                        unit: "rad/time"
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
        .navigationTitle("Ziegler–Nichols Ultimate Gain")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    ultimateGain:
                        try InputValidator.parseNumber(
                            ultimateGainInput,
                            fieldName:
                                "ultimate gain"
                        ),
                    ultimatePeriod:
                        try InputValidator.parseNumber(
                            ultimatePeriodInput,
                            fieldName:
                                "ultimate period"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        ultimateGainInput = "8"
        ultimatePeriodInput = "6"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        ultimateGainInput = ""
        ultimatePeriodInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ZieglerNicholsUltimateGainTuningView()
    }
}
