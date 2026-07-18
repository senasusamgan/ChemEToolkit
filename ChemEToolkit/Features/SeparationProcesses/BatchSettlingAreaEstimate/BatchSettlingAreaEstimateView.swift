import SwiftUI

struct BatchSettlingAreaEstimateView: View {

    @State private var flowInput = "100"

    @State private var velocityInput = "2"

    @State private var safetyInput = "1.25"

    @State private var aspectInput = "0.30"

    @State private var result: BatchSettlingAreaEstimateResult?
    @State private var errorMessage = ""

    private let engine = BatchSettlingAreaEstimateEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "circle.dotted.circle.fill",
                    title: "Batch Settling Area Estimate",
                    subtitle: "Estimate circular settler area and dimensions",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("Flow and settling-velocity time units must be consistent.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                    EngineeringInputField(
                        title: "Slurry Volumetric Flow",
                        symbol: "Q",
                        unit: "m3/h",
                        placeholder: "100",
                        text: $flowInput
                    )

                    EngineeringInputField(
                        title: "Design Settling Velocity",
                        symbol: "vs",
                        unit: "m/h",
                        placeholder: "2",
                        text: $velocityInput
                    )

                    EngineeringInputField(
                        title: "Hydraulic Safety Factor",
                        symbol: "SF",
                        unit: "—",
                        placeholder: "1.25",
                        text: $safetyInput
                    )

                    EngineeringInputField(
                        title: "Depth/Diameter Ratio",
                        symbol: "H/D",
                        unit: "—",
                        placeholder: "0.30",
                        text: $aspectInput
                    )

                        HStack {
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "circle.dotted.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                label: "Design Area",
                                value: numberFormatter.format(result.designArea),
                                unit: "m2"
                            ),
.init(
                                label: "Theoretical Area",
                                value: numberFormatter.format(result.theoreticalArea),
                                unit: "m2"
                            ),
.init(
                                label: "Equivalent Diameter",
                                value: numberFormatter.format(result.equivalentDiameter),
                                unit: "m"
                            ),
.init(
                                label: "Liquid Depth",
                                value: numberFormatter.format(result.liquidDepth),
                                unit: "m"
                            ),
.init(
                                label: "Design Volume",
                                value: numberFormatter.format(result.designVolume),
                                unit: "m3"
                            )
                                ],
                                tint: .purple
                            )

                            CalculatorInfoCard(tint: .purple) {
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
        .navigationTitle("Batch Settling Area Estimate")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                        slurryVolumetricFlow:
                            try InputValidator.parseNumber(
                                flowInput,
                                fieldName: "slurry volumetric flow"
                            ),
                        designSettlingVelocity:
                            try InputValidator.parseNumber(
                                velocityInput,
                                fieldName: "design settling velocity"
                            ),
                        hydraulicSafetyFactor:
                            try InputValidator.parseNumber(
                                safetyInput,
                                fieldName: "hydraulic safety factor"
                            ),
                        tankAspectRatio:
                            try InputValidator.parseNumber(
                                aspectInput,
                                fieldName: "depth/diameter ratio"
                            )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func resetInputs() {
        flowInput = ""
        velocityInput = ""
        safetyInput = ""
        aspectInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { BatchSettlingAreaEstimateView() }
}
