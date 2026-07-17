import SwiftUI

struct ValveCharacteristicsView: View {
    @State private var characteristic: ValveCharacteristicType = .equalPercentage
    @State private var openingInput = "50"
    @State private var ratedKvInput = "100"
    @State private var rangeabilityInput = "50"
    @State private var pressureDropInput = "1"
    @State private var densityInput = "1000"
    @State private var result: ValveCharacteristicsResult?
    @State private var errorMessage = ""

    private let engine = ValveCharacteristicsEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "slider.horizontal.3",
                    title: "Valve Characteristics",
                    subtitle: "Compare linear, equal-percentage and quick-opening trims",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Inherent valve characteristics relate valve travel to flow coefficient at constant pressure drop.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        VStack(alignment: .leading, spacing: AppSpacing.small) {
                            Text("Valve Characteristic").font(.headline)
                            Picker("Valve Characteristic", selection: $characteristic) {
                                ForEach(ValveCharacteristicType.allCases) { item in
                                    Text(item.title).tag(item)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        EngineeringInputField(title: "Valve Opening", symbol: "x", unit: "%", placeholder: "50", text: $openingInput)
                        EngineeringInputField(title: "Rated Kv", symbol: "Kv_max", unit: "m³/h", placeholder: "100", text: $ratedKvInput)
                        EngineeringInputField(title: "Rangeability", symbol: "R", unit: "—", placeholder: "50", text: $rangeabilityInput)
                        EngineeringInputField(title: "Pressure Drop", symbol: "ΔP", unit: "bar", placeholder: "1", text: $pressureDropInput)
                        EngineeringInputField(title: "Liquid Density", symbol: "ρ", unit: "kg/m³", placeholder: "1000", text: $densityInput)

                        HStack {
                            Button("Load Example", action: loadExample)
                            Spacer()
                            Button("Clear", role: .destructive, action: resetInputs)
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(title: "Calculate Valve Response", systemImage: "slider.horizontal.3", action: calculate)

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Relative Flow Coefficient", value: numberFormatter.format(result.relativeFlowCoefficient), unit: "—"),
                                    .init(label: "Effective Kv", value: numberFormatter.format(result.effectiveKv), unit: "m³/h"),
                                    .init(label: "Predicted Liquid Flow", value: numberFormatter.format(result.predictedLiquidFlow), unit: "m³/h"),
                                    .init(label: "Local Relative Slope", value: result.localRelativeSlope.isFinite ? numberFormatter.format(result.localRelativeSlope) : "Very steep at zero", unit: "—"),
                                    .init(label: "Characteristic", value: characteristic.title, unit: "—"),
                                    .init(label: "Behavior", value: result.characteristicDescription, unit: "—")
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
                                    Divider()
                                    Text(result.limitationDescription).foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty { CalculationErrorCard(message: errorMessage) }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
            .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
        }
        .navigationTitle("Valve Characteristics")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    characteristic: characteristic,
                    openingPercent: try InputValidator.parseNumber(openingInput, fieldName: "valve opening"),
                    ratedKv: try InputValidator.parseNumber(ratedKvInput, fieldName: "rated Kv"),
                    rangeability: try InputValidator.parseNumber(rangeabilityInput, fieldName: "rangeability"),
                    pressureDrop: try InputValidator.parseNumber(pressureDropInput, fieldName: "pressure drop"),
                    liquidDensity: try InputValidator.parseNumber(densityInput, fieldName: "liquid density")
                )
            )
        } catch { errorMessage = error.localizedDescription }
    }

    private func loadExample() {
        characteristic = .equalPercentage
        openingInput = "50"
        ratedKvInput = "100"
        rangeabilityInput = "50"
        pressureDropInput = "1"
        densityInput = "1000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        openingInput = ""
        ratedKvInput = ""
        rangeabilityInput = ""
        pressureDropInput = ""
        densityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview { NavigationStack { ValveCharacteristicsView() } }
