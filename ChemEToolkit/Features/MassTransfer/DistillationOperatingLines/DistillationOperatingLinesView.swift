import SwiftUI

struct DistillationOperatingLinesView: View {
    @State private var alphaInput = "2.5"
    @State private var distillateInput = "0.95"
    @State private var bottomsInput = "0.05"
    @State private var feedInput = "0.5"
    @State private var refluxInput = "2.5"
    @State private var qInput = "1"
    @State private var result: DistillationOperatingLinesResult?
    @State private var errorMessage = ""

    private let engine = DistillationOperatingLinesEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(symbolName: "chart.xyaxis.line", title: "Distillation Operating Lines", subtitle: "Calculate rectifying, feed and stripping lines with minimum reflux", tint: .blue)

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Constant Molar Overflow").font(.headline)
                        Text("yR = [R/(R+1)]x + xD/(R+1)")
                            .font(.system(size: 17, weight: .semibold))
                            .minimumScaleFactor(0.5)
                        Text("Total condenser and partial reboiler conventions are assumed. Reflux must exceed the q-line/equilibrium minimum.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        Text("VLE and Product Specifications").font(.headline)
                        EngineeringInputField(title: "Relative Volatility", symbol: "α", unit: "—", placeholder: "Example: 2.5", text: $alphaInput)
                        EngineeringInputField(title: "Distillate Light Fraction", symbol: "xD", unit: "—", placeholder: "Example: 0.95", text: $distillateInput)
                        EngineeringInputField(title: "Bottoms Light Fraction", symbol: "xB", unit: "—", placeholder: "Example: 0.05", text: $bottomsInput)
                        EngineeringInputField(title: "Feed Light Fraction", symbol: "zF", unit: "—", placeholder: "Example: 0.5", text: $feedInput)
                        Divider()
                        Text("Operating Conditions").font(.headline)
                        EngineeringInputField(title: "Reflux Ratio", symbol: "R", unit: "—", placeholder: "Example: 2.5", text: $refluxInput)
                        EngineeringInputField(title: "Feed Quality", symbol: "q", unit: "—", placeholder: "1 liquid, 0 vapor", text: $qInput)

                        MassTransferActionButtons(loadExample: loadExample, clear: resetInputs)
                        PrimaryActionButton(title: "Calculate Operating Lines", systemImage: "chart.xyaxis.line", action: calculate)

                        if let result {
                            CalculationResultCard(items: [
                                .init(label: "Rectifying Slope", value: formatter.format(result.rectifyingSlope), unit: "—"),
                                .init(label: "Rectifying Intercept", value: formatter.format(result.rectifyingIntercept), unit: "—"),
                                .init(label: "Feed Intersection x", value: formatter.format(result.feedIntersectionLiquidMoleFraction), unit: "—"),
                                .init(label: "Feed Intersection y", value: formatter.format(result.feedIntersectionVaporMoleFraction), unit: "—"),
                                .init(label: "Stripping Slope", value: formatter.format(result.strippingSlope), unit: "—"),
                                .init(label: "Stripping Intercept", value: formatter.format(result.strippingIntercept), unit: "—"),
                                .init(label: "Minimum Reflux Ratio", value: formatter.format(result.minimumRefluxRatio), unit: "—"),
                                .init(label: "Actual / Minimum Reflux", value: formatter.format(result.actualToMinimumRefluxRatio), unit: "—"),
                                .init(label: "Minimum-Reflux Pinch x", value: formatter.format(result.minimumRefluxPinchLiquidMoleFraction), unit: "—"),
                                .init(label: "Minimum-Reflux Pinch y", value: formatter.format(result.minimumRefluxPinchVaporMoleFraction), unit: "—")
                            ], tint: .blue)
                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Label("Feed and Reflux Interpretation", systemImage: "chart.xyaxis.line").font(.headline)
                                    Divider()
                                    Text(result.feedLineDescription).fontWeight(.semibold)
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
        .navigationTitle("Distillation Operating Lines")
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

#Preview { NavigationStack { DistillationOperatingLinesView() } }
