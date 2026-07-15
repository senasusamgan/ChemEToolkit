import SwiftUI

struct CSTRPFRSequenceView: View {
    @State private var concentrationInput = "10"
    @State private var flowInput = "0.002"
    @State private var cstrVolumeInput = "2"
    @State private var cstrRateInput = "0.001"
    @State private var pfrVolumeInput = "3"
    @State private var pfrRateInput = "0.002"

    @State private var result: CSTRPFRSequenceResult?
    @State private var errorMessage = ""

    private let engine = CSTRPFRSequenceEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.right.square.fill",
                    title: "CSTR–PFR Sequence",
                    subtitle: "Calculate a CSTR followed by a PFR with different kinetics",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("C₁ = C₀/(1+k_Cτ_C), C₂ = C₁e^(−k_Pτ_P)")
                            .font(.headline)

                        Text("Different rate constants can represent different temperatures or catalyst conditions.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title: "Inlet Concentration",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "Example: 10",
                            text: $concentrationInput
                        )

                        EngineeringInputField(
                            title: "Volumetric Flow Rate",
                            symbol: "v₀",
                            unit: "m³/s",
                            placeholder: "Example: 0.002",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "CSTR Volume",
                            symbol: "V_C",
                            unit: "m³",
                            placeholder: "Example: 2",
                            text: $cstrVolumeInput
                        )

                        EngineeringInputField(
                            title: "CSTR Rate Constant",
                            symbol: "k_C",
                            unit: "1/s",
                            placeholder: "Example: 0.001",
                            text: $cstrRateInput
                        )

                        EngineeringInputField(
                            title: "PFR Volume",
                            symbol: "V_P",
                            unit: "m³",
                            placeholder: "Example: 3",
                            text: $pfrVolumeInput
                        )

                        EngineeringInputField(
                            title: "PFR Rate Constant",
                            symbol: "k_P",
                            unit: "1/s",
                            placeholder: "Example: 0.002",
                            text: $pfrRateInput
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
                            title: "Calculate",
                            systemImage: "arrow.right.square.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "CSTR Outlet Concentration",
                                            value: numberFormatter.format(
                                                result.cstrOutletConcentration
                                            ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label: "Final Outlet Concentration",
                                            value: numberFormatter.format(
                                                result.finalOutletConcentration
                                            ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label: "CSTR-Stage Conversion",
                                            value: numberFormatter.format(
                                                100 * result.cstrStageConversion
                                            ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label: "PFR Increment on Feed",
                                            value: numberFormatter.format(
                                                100 * result.pfrIncrementalConversionOnFeed
                                            ),
                                            unit: "percentage points"
                                        ),
                                        .init(
                                            label: "Overall Conversion",
                                            value: numberFormatter.format(
                                                100 * result.overallConversion
                                            ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label: "Total Space Time",
                                            value: numberFormatter.format(
                                                result.totalSpaceTime
                                            ),
                                            unit: "s"
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

                                        Text(result.limitationDescription)
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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("CSTR–PFR Sequence")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    inletConcentration:
                        try InputValidator.parseNumber(
                            concentrationInput,
                            fieldName: "inlet concentration"
                        ),
                    volumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName: "volumetric flow rate"
                        ),
                    cstrVolume:
                        try InputValidator.parseNumber(
                            cstrVolumeInput,
                            fieldName: "cstr volume"
                        ),
                    cstrRateConstant:
                        try InputValidator.parseNumber(
                            cstrRateInput,
                            fieldName: "cstr rate constant"
                        ),
                    pfrVolume:
                        try InputValidator.parseNumber(
                            pfrVolumeInput,
                            fieldName: "pfr volume"
                        ),
                    pfrRateConstant:
                        try InputValidator.parseNumber(
                            pfrRateInput,
                            fieldName: "pfr rate constant"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "10"
        flowInput = "0.002"
        cstrVolumeInput = "2"
        cstrRateInput = "0.001"
        pfrVolumeInput = "3"
        pfrRateInput = "0.002"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        flowInput = ""
        cstrVolumeInput = ""
        cstrRateInput = ""
        pfrVolumeInput = ""
        pfrRateInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CSTRPFRSequenceView()
    }
}
