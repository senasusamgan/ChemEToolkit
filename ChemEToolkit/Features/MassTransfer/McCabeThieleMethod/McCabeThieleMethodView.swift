import SwiftUI

struct McCabeThieleMethodView: View {
    @State private var alphaInput = "2.5"
    @State private var distillateInput = "0.95"
    @State private var bottomsInput = "0.05"
    @State private var feedInput = "0.5"
    @State private var refluxInput = "2.5"
    @State private var qInput = "1"
    @State private var result: McCabeThieleMethodResult?
    @State private var errorMessage = ""

    private let engine = McCabeThieleMethodEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(symbolName: "square.stack.3d.up", title: "McCabe–Thiele Method", subtitle: "Estimate binary theoretical stages, feed stage and reflux requirement", tint: .blue)

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Binary Equilibrium-Stage Stepping").font(.headline)
                        Text("Equilibrium curve ↔ operating lines")
                            .font(.system(size: 19, weight: .semibold))
                        Text("Assumes constant relative volatility, constant molar overflow, a total condenser and a partial reboiler.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        Text("VLE and Separation Targets").font(.headline)
                        EngineeringInputField(title: "Relative Volatility", symbol: "α", unit: "—", placeholder: "Example: 2.5", text: $alphaInput)
                        EngineeringInputField(title: "Distillate Light Fraction", symbol: "xD", unit: "—", placeholder: "Example: 0.95", text: $distillateInput)
                        EngineeringInputField(title: "Bottoms Light Fraction", symbol: "xB", unit: "—", placeholder: "Example: 0.05", text: $bottomsInput)
                        EngineeringInputField(title: "Feed Light Fraction", symbol: "zF", unit: "—", placeholder: "Example: 0.5", text: $feedInput)
                        Divider()
                        Text("Column Operating Conditions").font(.headline)
                        EngineeringInputField(title: "Reflux Ratio", symbol: "R", unit: "—", placeholder: "Example: 2.5", text: $refluxInput)
                        EngineeringInputField(title: "Feed Quality", symbol: "q", unit: "—", placeholder: "1 liquid, 0 vapor", text: $qInput)

                        MassTransferActionButtons(loadExample: loadExample, clear: resetInputs)
                        PrimaryActionButton(title: "Step Theoretical Stages", systemImage: "square.stack.3d.up", action: calculate)

                        if let result {
                            CalculationResultCard(items: [
                                .init(label: "Continuous Theoretical Stages", value: formatter.format(result.continuousTheoreticalStageCount), unit: "stages"),
                                .init(label: "Required Whole Stages", value: String(result.requiredWholeStageCount), unit: "stages"),
                                .init(label: "Feed Stage Number", value: String(result.feedStageNumber), unit: "stage"),
                                .init(label: "Final Stage Fraction", value: formatter.format(result.finalStageFraction), unit: "—"),
                                .init(label: "Minimum Reflux Ratio", value: formatter.format(result.minimumRefluxRatio), unit: "—"),
                                .init(label: "Actual / Minimum Reflux", value: formatter.format(result.actualToMinimumRefluxRatio), unit: "—"),
                                .init(label: "Rectifying Slope", value: formatter.format(result.rectifyingSlope), unit: "—"),
                                .init(label: "Stripping Slope", value: formatter.format(result.strippingSlope), unit: "—"),
                                .init(label: "Feed Intersection x", value: formatter.format(result.feedIntersectionLiquidMoleFraction), unit: "—")
                            ], tint: .blue)
                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Label("Stage-Counting Basis", systemImage: "square.stack.3d.up").font(.headline)
                                    Divider()
                                    Text(result.countingConvention).fontWeight(.semibold)
                                    Text("\(result.stageLiquidCompositions.count) equilibrium contacts were generated.").foregroundStyle(.secondary)
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
        .navigationTitle("McCabe–Thiele Method")
    }

    private func calculate() {
        clearResult()
        do {
            result = try engine.calculate(.init(
                relativeVolatility: try InputValidator.parseNumber(alphaInput, fieldName: "relative volatility"),
                distillateLightMoleFraction: try InputValidator.parseNumber(distillateInput, fieldName: "distillate light fraction"),
                bottomsLightMoleFraction: try InputValidator.parseNumber(bottomsInput, fieldName: "bottoms light fraction"),
                feedLightMoleFraction: try InputValidator.parseNumber(feedInput, fieldName: "feed light fraction"),
                refluxRatio: try InputValidator.parseNumber(refluxInput, fieldName: "reflux ratio"),
                feedQuality: try InputValidator.parseNumber(qInput, fieldName: "feed quality")
            ))
        } catch { errorMessage = MassTransferViewSupport.errorMessage(for: error) }
    }

    private func loadExample() { alphaInput = "2.5"; distillateInput = "0.95"; bottomsInput = "0.05"; feedInput = "0.5"; refluxInput = "2.5"; qInput = "1"; clearResult() }
    private func resetInputs() { alphaInput = ""; distillateInput = ""; bottomsInput = ""; feedInput = ""; refluxInput = ""; qInput = ""; clearResult() }
    private func clearResult() { result = nil; errorMessage = "" }
}

#Preview { NavigationStack { McCabeThieleMethodView() } }
