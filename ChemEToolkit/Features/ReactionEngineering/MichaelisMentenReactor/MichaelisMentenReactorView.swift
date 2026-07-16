import SwiftUI

struct MichaelisMentenReactorView: View {
    @State private var substrateInput = "10"
    @State private var flowInput = "1"
    @State private var maximumRateInput = "2"
    @State private var michaelisInput = "3"
    @State private var conversionInput = "0.8"
    @State private var result: MichaelisMentenReactorResult?
    @State private var errorMessage = ""

    private let engine = MichaelisMentenReactorEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "function",
                    title: "Michaelis–Menten Reactor",
                    subtitle: "Compare PFR and CSTR size for enzyme-catalyzed conversion",
                    tint: .orange
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Inlet Substrate",
                            symbol: "S₀",
                            unit: "mol/m³",
                            placeholder: "10",
                            text: $substrateInput
                        )

                        EngineeringInputField(
                            title: "Volumetric Flow Rate",
                            symbol: "Q",
                            unit: "m³/time",
                            placeholder: "1",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Maximum Volumetric Rate",
                            symbol: "V_max",
                            unit: "mol/(m³·time)",
                            placeholder: "2",
                            text: $maximumRateInput
                        )

                        EngineeringInputField(
                            title: "Michaelis Constant",
                            symbol: "K_m",
                            unit: "mol/m³",
                            placeholder: "3",
                            text: $michaelisInput
                        )

                        EngineeringInputField(
                            title: "Target Conversion",
                            symbol: "X",
                            unit: "—",
                            placeholder: "0.8",
                            text: $conversionInput
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
                            systemImage: "function",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Outlet Substrate", value: formatter.format(result.outletSubstrateConcentration), unit: "mol/m³"),
.init(label: "PFR Volume", value: formatter.format(result.pfrVolume), unit: "m³"),
.init(label: "CSTR Volume", value: formatter.format(result.cstrVolume), unit: "m³"),
.init(label: "CSTR / PFR Volume", value: formatter.format(result.cstrToPFRVolumeRatio), unit: "—"),
.init(label: "Inlet Rate", value: formatter.format(result.inletReactionRate), unit: "mol/(m³·time)"),
.init(label: "Outlet Rate", value: formatter.format(result.outletReactionRate), unit: "mol/(m³·time)")
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
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
        .navigationTitle("Michaelis–Menten Reactor")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    inletSubstrateConcentration: try InputValidator.parseNumber(substrateInput, fieldName: "inlet substrate"),
                    volumetricFlowRate: try InputValidator.parseNumber(flowInput, fieldName: "flow rate"),
                    maximumVolumetricRate: try InputValidator.parseNumber(maximumRateInput, fieldName: "maximum rate"),
                    michaelisConstant: try InputValidator.parseNumber(michaelisInput, fieldName: "Michaelis constant"),
                    targetSubstrateConversion: try InputValidator.parseNumber(conversionInput, fieldName: "target conversion")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        substrateInput = "10"
        flowInput = "1"
        maximumRateInput = "2"
        michaelisInput = "3"
        conversionInput = "0.8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        substrateInput = ""
        flowInput = ""
        maximumRateInput = ""
        michaelisInput = ""
        conversionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { MichaelisMentenReactorView() }
}
