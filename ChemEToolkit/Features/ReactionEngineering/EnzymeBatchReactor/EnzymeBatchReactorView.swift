import SwiftUI

struct EnzymeBatchReactorView: View {
    @State private var volumeInput = "2"
    @State private var substrateInput = "10"
    @State private var maximumRateInput = "2"
    @State private var michaelisInput = "3"
    @State private var conversionInput = "0.8"
    @State private var result: EnzymeBatchReactorResult?
    @State private var errorMessage = ""

    private let engine = EnzymeBatchReactorEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "flask.fill",
                    title: "Enzyme Batch Reactor",
                    subtitle: "Calculate batch time and product formation with Michaelis–Menten kinetics",
                    tint: .orange
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Liquid Volume",
                            symbol: "V",
                            unit: "m³",
                            placeholder: "2",
                            text: $volumeInput
                        )

                        EngineeringInputField(
                            title: "Initial Substrate",
                            symbol: "S₀",
                            unit: "mol/m³",
                            placeholder: "10",
                            text: $substrateInput
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
                            systemImage: "flask.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Batch Time", value: formatter.format(result.timeToTargetConversion), unit: "time"),
.init(label: "Final Substrate", value: formatter.format(result.finalSubstrateConcentration), unit: "mol/m³"),
.init(label: "Product Concentration", value: formatter.format(result.productConcentration), unit: "mol/m³"),
.init(label: "Product Moles", value: formatter.format(result.productMoles), unit: "mol"),
.init(label: "Initial Rate", value: formatter.format(result.initialReactionRate), unit: "mol/(m³·time)"),
.init(label: "Final Rate", value: formatter.format(result.finalReactionRate), unit: "mol/(m³·time)")
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
        .navigationTitle("Enzyme Batch Reactor")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    liquidVolume: try InputValidator.parseNumber(volumeInput, fieldName: "liquid volume"),
                    initialSubstrateConcentration: try InputValidator.parseNumber(substrateInput, fieldName: "initial substrate"),
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
        volumeInput = "2"
        substrateInput = "10"
        maximumRateInput = "2"
        michaelisInput = "3"
        conversionInput = "0.8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        volumeInput = ""
        substrateInput = ""
        maximumRateInput = ""
        michaelisInput = ""
        conversionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { EnzymeBatchReactorView() }
}
