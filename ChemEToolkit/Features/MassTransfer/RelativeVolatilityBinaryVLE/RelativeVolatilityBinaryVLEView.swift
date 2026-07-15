import SwiftUI

struct RelativeVolatilityBinaryVLEView: View {
    @State private var mode: BinaryVLECalculationMode = .liquidToVapor
    @State private var alphaInput = "2.5"
    @State private var compositionInput = "0.4"
    @State private var result: RelativeVolatilityBinaryVLEResult?
    @State private var errorMessage = ""

    private let engine = RelativeVolatilityBinaryVLEEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.up.right.circle.fill",
                    title: "Relative Volatility & Binary VLE",
                    subtitle: "Convert binary liquid and vapor equilibrium compositions",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Constant Relative Volatility").font(.headline)
                        Text("y = αx / [1 + (α − 1)x]")
                            .font(.system(size: 20, weight: .semibold))
                        Text("The selected component is the more volatile component, so α must exceed one.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        Text("Calculation Direction").font(.headline)
                        Picker("Calculation Direction", selection: $mode) {
                            ForEach(BinaryVLECalculationMode.allCases) { Text($0.title).tag($0) }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                        .onChange(of: mode) { loadExample() }

                        EngineeringInputField(title: "Relative Volatility", symbol: "α", unit: "—", placeholder: "Example: 2.5", text: $alphaInput)
                        EngineeringInputField(
                            title: mode == .liquidToVapor ? "Liquid Mole Fraction" : "Vapor Mole Fraction",
                            symbol: mode == .liquidToVapor ? "x" : "y",
                            unit: "—",
                            placeholder: mode == .liquidToVapor ? "Example: 0.4" : "Example: 0.625",
                            text: $compositionInput
                        )

                        MassTransferActionButtons(loadExample: loadExample, clear: resetInputs)
                        PrimaryActionButton(title: "Calculate Equilibrium Composition", systemImage: "arrow.up.right.circle.fill", action: calculate)

                        if let result {
                            CalculationResultCard(items: [
                                .init(label: "Liquid Mole Fraction", value: formatter.format(result.liquidMoleFraction), unit: "—"),
                                .init(label: "Vapor Mole Fraction", value: formatter.format(result.vaporMoleFraction), unit: "—"),
                                .init(label: "Equilibrium Gap, y − x", value: formatter.format(result.equilibriumGap), unit: "—"),
                                .init(label: "Vapor Enrichment, y/x", value: formatter.format(result.vaporEnrichmentFactor), unit: "—")
                            ], tint: .blue)
                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Label("Equilibrium Interpretation", systemImage: "arrow.up.right.circle.fill").font(.headline)
                                    Divider()
                                    Text(result.interpretation).fontWeight(.semibold)
                                    Text(result.modelName).foregroundStyle(.secondary)
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
        .navigationTitle("Relative Volatility & VLE")
    }

    private func calculate() {
        clearResult()
        do {
            result = try engine.calculate(.init(
                mode: mode,
                relativeVolatility: try InputValidator.parseNumber(alphaInput, fieldName: "relative volatility"),
                specifiedMoleFraction: try InputValidator.parseNumber(compositionInput, fieldName: "specified mole fraction")
            ))
        } catch { errorMessage = MassTransferViewSupport.errorMessage(for: error) }
    }

    private func loadExample() {
        alphaInput = "2.5"
        compositionInput = mode == .liquidToVapor ? "0.4" : "0.625"
        clearResult()
    }

    private func resetInputs() { alphaInput = ""; compositionInput = ""; clearResult() }
    private func clearResult() { result = nil; errorMessage = "" }
}

#Preview { NavigationStack { RelativeVolatilityBinaryVLEView() } }
