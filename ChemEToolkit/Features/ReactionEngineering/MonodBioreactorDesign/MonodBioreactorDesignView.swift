import SwiftUI

struct MonodBioreactorDesignView: View {
    @State private var feedInput = "20"
    @State private var targetInput = "2"
    @State private var growthInput = "0.5"
    @State private var monodInput = "1"
    @State private var yieldInput = "0.6"
    @State private var decayInput = "0.05"
    @State private var flowInput = "10"
    @State private var result: MonodBioreactorDesignResult?
    @State private var errorMessage = ""

    private let engine = MonodBioreactorDesignEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "microbe.fill",
                    title: "Monod Bioreactor Design",
                    subtitle: "Size a continuous bioreactor for target effluent substrate",
                    tint: .orange
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Feed Substrate",
                            symbol: "S₀",
                            unit: "kg/m³",
                            placeholder: "20",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Target Effluent Substrate",
                            symbol: "S",
                            unit: "kg/m³",
                            placeholder: "2",
                            text: $targetInput
                        )

                        EngineeringInputField(
                            title: "Maximum Growth Rate",
                            symbol: "μ_max",
                            unit: "1/time",
                            placeholder: "0.5",
                            text: $growthInput
                        )

                        EngineeringInputField(
                            title: "Monod Constant",
                            symbol: "K_s",
                            unit: "kg/m³",
                            placeholder: "1",
                            text: $monodInput
                        )

                        EngineeringInputField(
                            title: "Biomass Yield",
                            symbol: "Y_X/S",
                            unit: "kg/kg",
                            placeholder: "0.6",
                            text: $yieldInput
                        )

                        EngineeringInputField(
                            title: "Biomass Decay Rate",
                            symbol: "k_d",
                            unit: "1/time",
                            placeholder: "0.05",
                            text: $decayInput
                        )

                        EngineeringInputField(
                            title: "Volumetric Flow Rate",
                            symbol: "Q",
                            unit: "m³/time",
                            placeholder: "10",
                            text: $flowInput
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
                            systemImage: "microbe.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Reactor Volume", value: formatter.format(result.requiredReactorVolume), unit: "m³"),
.init(label: "Residence Time", value: formatter.format(result.hydraulicResidenceTime), unit: "time"),
.init(label: "Dilution Rate", value: formatter.format(result.dilutionRate), unit: "1/time"),
.init(label: "Biomass Concentration", value: formatter.format(result.biomassConcentration), unit: "kg/m³"),
.init(label: "Substrate Conversion", value: formatter.format(100 * result.substrateConversionFraction), unit: "%"),
.init(label: "Dilution / Washout", value: formatter.format(result.washoutSafetyRatio), unit: "—")
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
        .navigationTitle("Monod Bioreactor Design")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    feedSubstrateConcentration: try InputValidator.parseNumber(feedInput, fieldName: "feed substrate"),
                    targetEffluentSubstrate: try InputValidator.parseNumber(targetInput, fieldName: "target effluent substrate"),
                    maximumSpecificGrowthRate: try InputValidator.parseNumber(growthInput, fieldName: "maximum growth rate"),
                    monodHalfSaturationConstant: try InputValidator.parseNumber(monodInput, fieldName: "Monod constant"),
                    biomassYieldCoefficient: try InputValidator.parseNumber(yieldInput, fieldName: "biomass yield"),
                    biomassDecayRate: try InputValidator.parseNumber(decayInput, fieldName: "biomass decay rate"),
                    volumetricFlowRate: try InputValidator.parseNumber(flowInput, fieldName: "flow rate")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        feedInput = "20"
        targetInput = "2"
        growthInput = "0.5"
        monodInput = "1"
        yieldInput = "0.6"
        decayInput = "0.05"
        flowInput = "10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        targetInput = ""
        growthInput = ""
        monodInput = ""
        yieldInput = ""
        decayInput = ""
        flowInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { MonodBioreactorDesignView() }
}
