import SwiftUI

struct CatalystRegenerationCycleView:
    View {

    @State private var initialActivityInput =
        "1"

    @State private var rateConstantInput =
        "0.1"

    @State private var operatingTimeInput =
        "5"

    @State private var recoveryInput =
        "0.8"

    @State private var cycleCountInput =
        "3"

    @State private var result:
        CatalystRegenerationCycleResult?

    @State private var errorMessage = ""

    private let engine =
        CatalystRegenerationCycleEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.triangle.2.circlepath.circle.fill",
                    title:
                        "Catalyst Regeneration Cycle",
                    subtitle:
                        "Track activity across repeated operation and regeneration cycles",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Operation–Regeneration Sequence")
                            .font(.headline)

                        Text(
                            "a_after = a_before + r(1−a_before)"
                        )
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )

                        Text(
                            "The regeneration recovery fraction acts on activity lost during the operating period."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
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
                            title: "Initial Activity",
                            symbol: "a₀",
                            unit: "—",
                            placeholder: "1",
                            text:
                                $initialActivityInput
                        )

                        EngineeringInputField(
                            title:
                                "Deactivation Rate Constant",
                            symbol: "k_d",
                            unit: "1/time",
                            placeholder: "0.1",
                            text:
                                $rateConstantInput
                        )

                        EngineeringInputField(
                            title:
                                "Operating Time per Cycle",
                            symbol: "t_cycle",
                            unit: "time",
                            placeholder: "5",
                            text:
                                $operatingTimeInput
                        )

                        EngineeringInputField(
                            title:
                                "Regeneration Recovery Fraction",
                            symbol: "r",
                            unit: "—",
                            placeholder: "0.8",
                            text: $recoveryInput
                        )

                        EngineeringInputField(
                            title: "Number of Cycles",
                            symbol: "N",
                            unit: "whole number",
                            placeholder: "3",
                            text: $cycleCountInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
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
                                "Calculate Regeneration Cycles",
                            systemImage:
                                "arrow.triangle.2.circlepath.circle.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Final Activity Before Regeneration",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalActivityBeforeRegeneration
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Final Activity After Regeneration",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalActivityAfterRegeneration
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Minimum Activity Observed",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .minimumActivityObserved
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Average Operating Activity",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .averageOperatingActivity
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Equivalent Full-Activity Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .equivalentFullActivityOperatingTime
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Cycles Evaluated",
                                            value:
                                                "\(result.numberOfCycles)",
                                            unit: "cycles"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
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
        .navigationTitle("Catalyst Regeneration")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialActivity:
                        try InputValidator.parseNumber(
                            initialActivityInput,
                            fieldName:
                                "initial activity"
                        ),
                    deactivationRateConstant:
                        try InputValidator.parseNumber(
                            rateConstantInput,
                            fieldName:
                                "deactivation rate constant"
                        ),
                    operatingTimePerCycle:
                        try InputValidator.parseNumber(
                            operatingTimeInput,
                            fieldName:
                                "operating time per cycle"
                        ),
                    regenerationRecoveryFraction:
                        try InputValidator.parseNumber(
                            recoveryInput,
                            fieldName:
                                "regeneration recovery fraction"
                        ),
                    numberOfCycles:
                        try InputValidator.parseNumber(
                            cycleCountInput,
                            fieldName:
                                "number of cycles"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialActivityInput = "1"
        rateConstantInput = "0.1"
        operatingTimeInput = "5"
        recoveryInput = "0.8"
        cycleCountInput = "3"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialActivityInput = ""
        rateConstantInput = ""
        operatingTimeInput = ""
        recoveryInput = ""
        cycleCountInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CatalystRegenerationCycleView()
    }
}
