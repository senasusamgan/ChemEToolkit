import SwiftUI

struct SafetyIntegrityLevelTargetView:
    View {

    @State private var unmitigatedFrequencyInput = "0.1"
    @State private var tolerableFrequencyInput = "0.00001"
    @State private var nonSISRRFInput = "10"

    @State private var result:
        SafetyIntegrityLevelTargetResult?

    @State private var errorMessage = ""

    private let engine =
        SafetyIntegrityLevelTargetEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "shield.fill",
                    title: "Safety Integrity Level Target",
                    subtitle: "Screen the low-demand SIF risk-reduction requirement",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The module calculates the frequency gap remaining after credited non-SIS protection and maps it to a conventional low-demand SIL band.")
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
                            title: "Unmitigated Event Frequency",
                            symbol: "f_U",
                            unit: "1/year",
                            placeholder: "0.1",
                            text: $unmitigatedFrequencyInput
                        )

                        EngineeringInputField(
                            title: "Tolerable Event Frequency",
                            symbol: "f_T",
                            unit: "1/year",
                            placeholder: "0.00001",
                            text: $tolerableFrequencyInput
                        )

                        EngineeringInputField(
                            title: "Non-SIS Risk Reduction Factor",
                            symbol: "RRF_non-SIS",
                            unit: "—",
                            placeholder: "10",
                            text: $nonSISRRFInput
                        )

                        HStack(spacing: AppSpacing.medium) {
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
                            title: "Calculate",
                            systemImage: "shield.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Frequency after Non-SIS Protection",
                                        value: numberFormatter.format(result.frequencyAfterNonSISProtection),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Required SIF RRF",
                                        value: numberFormatter.format(result.requiredSIFRiskReductionFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Required Average PFD",
                                        value: numberFormatter.format(result.requiredAveragePFD),
                                        unit: "—"
                                    ),
.init(
                                        label: "Target Band",
                                        value: result.targetBand,
                                        unit: "—"
                                    ),
.init(
                                        label: "Non-SIS Protection Sufficient",
                                        value: result.nonSISProtectionIsSufficient ? "Yes" : "No",
                                        unit: "—"
                                    ),
.init(
                                        label: "Assessment",
                                        value: result.targetDescription,
                                        unit: "—"
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
        .navigationTitle("Safety Integrity Level Target")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    unmitigatedEventFrequency:
                        try InputValidator.parseNumber(
                            unmitigatedFrequencyInput,
                            fieldName:
                                "unmitigated event frequency"
                        ),
                    tolerableEventFrequency:
                        try InputValidator.parseNumber(
                            tolerableFrequencyInput,
                            fieldName:
                                "tolerable event frequency"
                        ),
                    nonSISRiskReductionFactor:
                        try InputValidator.parseNumber(
                            nonSISRRFInput,
                            fieldName:
                                "non-SIS risk-reduction factor"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        unmitigatedFrequencyInput = "0.1"
        tolerableFrequencyInput = "0.00001"
        nonSISRRFInput = "10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        unmitigatedFrequencyInput = ""
        tolerableFrequencyInput = ""
        nonSISRRFInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SafetyIntegrityLevelTargetView()
    }
}
