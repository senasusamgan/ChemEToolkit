import SwiftUI

struct BinaryFlashCalculationView: View {
    @State private var feedFlowInput = "100"
    @State private var feedCompositionInput = "0.5"
    @State private var lightKInput = "2"
    @State private var heavyKInput = "0.5"
    @State private var result: BinaryFlashCalculationResult?
    @State private var errorMessage = ""

    private let engine = BinaryFlashCalculationEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(symbolName: "circle.lefthalf.filled", title: "Binary Flash Calculation", subtitle: "Determine phase state, vapor fraction and equilibrium compositions", tint: .blue)

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Rachford–Rice Flash").font(.headline)
                        Text("Σ zᵢ(Kᵢ − 1) / [1 + β(Kᵢ − 1)] = 0")
                            .font(.system(size: 17, weight: .semibold))
                            .minimumScaleFactor(0.5)
                        Text("Constant K-values are assumed. Bubble, dew, two-phase and single-phase states are identified explicitly.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        Text("Feed").font(.headline)
                        EngineeringInputField(title: "Feed Flow Rate", symbol: "F", unit: "mol/s", placeholder: "Example: 100", text: $feedFlowInput)
                        EngineeringInputField(title: "Feed Light-Component Fraction", symbol: "zL", unit: "—", placeholder: "Example: 0.5", text: $feedCompositionInput)
                        Divider()
                        Text("Equilibrium Ratios").font(.headline)
                        EngineeringInputField(title: "Light-Component K-Value", symbol: "KL", unit: "—", placeholder: "Example: 2", text: $lightKInput)
                        EngineeringInputField(title: "Heavy-Component K-Value", symbol: "KH", unit: "—", placeholder: "Example: 0.5", text: $heavyKInput)

                        MassTransferActionButtons(loadExample: loadExample, clear: resetInputs)
                        PrimaryActionButton(title: "Solve Binary Flash", systemImage: "circle.lefthalf.filled", action: calculate)

                        if let result {
                            CalculationResultCard(items: [
                                .init(label: "Vapor Fraction", value: formatter.format(result.vaporFraction), unit: "—"),
                                .init(label: "Liquid Fraction", value: formatter.format(result.liquidFraction), unit: "—"),
                                .init(label: "Vapor Flow", value: formatter.format(result.vaporFlowRate), unit: "mol/s"),
                                .init(label: "Liquid Flow", value: formatter.format(result.liquidFlowRate), unit: "mol/s"),
                                .init(label: "Vapor Light Fraction", value: formatter.format(result.vaporLightMoleFraction), unit: "—"),
                                .init(label: "Liquid Light Fraction", value: formatter.format(result.liquidLightMoleFraction), unit: "—"),
                                .init(label: "Rachford–Rice Residual", value: formatter.format(result.rachfordRiceResidual), unit: "—")
                            ], tint: .blue)
                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Label(result.phaseState.title, systemImage: "circle.lefthalf.filled").font(.headline)
                                    Divider()
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
        .navigationTitle("Binary Flash Calculation")
    }

    private func calculate() {
        clearResult()
        do {
            result = try engine.calculate(.init(
                feedFlowRate: try InputValidator.parseNumber(feedFlowInput, fieldName: "feed flow rate"),
                feedLightMoleFraction: try InputValidator.parseNumber(feedCompositionInput, fieldName: "feed light fraction"),
                lightComponentKValue: try InputValidator.parseNumber(lightKInput, fieldName: "light-component K-value"),
                heavyComponentKValue: try InputValidator.parseNumber(heavyKInput, fieldName: "heavy-component K-value")
            ))
        } catch { errorMessage = MassTransferViewSupport.errorMessage(for: error) }
    }

    private func loadExample() { feedFlowInput = "100"; feedCompositionInput = "0.5"; lightKInput = "2"; heavyKInput = "0.5"; clearResult() }
    private func resetInputs() { feedFlowInput = ""; feedCompositionInput = ""; lightKInput = ""; heavyKInput = ""; clearResult() }
    private func clearResult() { result = nil; errorMessage = "" }
}

#Preview { NavigationStack { BinaryFlashCalculationView() } }
