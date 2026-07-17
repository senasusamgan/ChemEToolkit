import SwiftUI

struct LayerOfProtectionAnalysisView:
    View {

    @State private var initiatingFrequencyInput = "0.1"
    @State private var enablingProbabilityInput = "0.5"
    @State private var conditionalProbabilityInput = "0.2"
    @State private var ipl1Input = "0.1"
    @State private var ipl2Input = "0.1"
    @State private var ipl3Input = "1"
    @State private var tolerableFrequencyInput = "0.0001"

    @State private var result:
        LayerOfProtectionAnalysisResult?

    @State private var errorMessage = ""

    private let engine =
        LayerOfProtectionAnalysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.stack.3d.up.fill",
                    title: "Layer of Protection Analysis",
                    subtitle: "Screen scenario frequency through independent protection layers",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Enter initiating frequency, conditional probabilities and up to three credited IPL probabilities of failure on demand.")
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
                            title: "Initiating Event Frequency",
                            symbol: "f_IE",
                            unit: "1/year",
                            placeholder: "0.1",
                            text: $initiatingFrequencyInput
                        )

                        EngineeringInputField(
                            title: "Enabling Condition Probability",
                            symbol: "P_E",
                            unit: "—",
                            placeholder: "0.5",
                            text: $enablingProbabilityInput
                        )

                        EngineeringInputField(
                            title: "Conditional Modifier Probability",
                            symbol: "P_C",
                            unit: "—",
                            placeholder: "0.2",
                            text: $conditionalProbabilityInput
                        )

                        EngineeringInputField(
                            title: "Protection Layer 1 PFD",
                            symbol: "PFD₁",
                            unit: "—",
                            placeholder: "0.1",
                            text: $ipl1Input
                        )

                        EngineeringInputField(
                            title: "Protection Layer 2 PFD",
                            symbol: "PFD₂",
                            unit: "—",
                            placeholder: "0.1",
                            text: $ipl2Input
                        )

                        EngineeringInputField(
                            title: "Protection Layer 3 PFD",
                            symbol: "PFD₃",
                            unit: "1 means no credited layer",
                            placeholder: "1",
                            text: $ipl3Input
                        )

                        EngineeringInputField(
                            title: "Tolerable Event Frequency",
                            symbol: "f_T",
                            unit: "1/year",
                            placeholder: "0.0001",
                            text: $tolerableFrequencyInput
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
                            systemImage: "square.stack.3d.up.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Unmitigated Frequency",
                                        value: numberFormatter.format(result.unmitigatedScenarioFrequency),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Combined IPL PFD",
                                        value: numberFormatter.format(result.combinedProtectionLayerPFD),
                                        unit: "—"
                                    ),
.init(
                                        label: "Mitigated Frequency",
                                        value: numberFormatter.format(result.mitigatedScenarioFrequency),
                                        unit: "1/year"
                                    ),
.init(
                                        label: "Achieved Risk Reduction",
                                        value: numberFormatter.format(result.achievedRiskReductionFactor),
                                        unit: "RRF"
                                    ),
.init(
                                        label: "Additional RRF Required",
                                        value: numberFormatter.format(result.requiredAdditionalRiskReductionFactor),
                                        unit: "RRF"
                                    ),
.init(
                                        label: "Target Met",
                                        value: result.targetIsMet ? "Yes" : "No",
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
        .navigationTitle("Layer of Protection Analysis")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initiatingEventFrequency:
                        try InputValidator.parseNumber(
                            initiatingFrequencyInput,
                            fieldName:
                                "initiating event frequency"
                        ),
                    enablingConditionProbability:
                        try InputValidator.parseNumber(
                            enablingProbabilityInput,
                            fieldName:
                                "enabling condition probability"
                        ),
                    conditionalModifierProbability:
                        try InputValidator.parseNumber(
                            conditionalProbabilityInput,
                            fieldName:
                                "conditional modifier probability"
                        ),
                    protectionLayer1PFD:
                        try InputValidator.parseNumber(
                            ipl1Input,
                            fieldName:
                                "protection layer 1 PFD"
                        ),
                    protectionLayer2PFD:
                        try InputValidator.parseNumber(
                            ipl2Input,
                            fieldName:
                                "protection layer 2 PFD"
                        ),
                    protectionLayer3PFD:
                        try InputValidator.parseNumber(
                            ipl3Input,
                            fieldName:
                                "protection layer 3 PFD"
                        ),
                    tolerableEventFrequency:
                        try InputValidator.parseNumber(
                            tolerableFrequencyInput,
                            fieldName:
                                "tolerable event frequency"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initiatingFrequencyInput = "0.1"
        enablingProbabilityInput = "0.5"
        conditionalProbabilityInput = "0.2"
        ipl1Input = "0.1"
        ipl2Input = "0.1"
        ipl3Input = "1"
        tolerableFrequencyInput = "0.0001"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initiatingFrequencyInput = ""
        enablingProbabilityInput = ""
        conditionalProbabilityInput = ""
        ipl1Input = ""
        ipl2Input = ""
        ipl3Input = ""
        tolerableFrequencyInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LayerOfProtectionAnalysisView()
    }
}
