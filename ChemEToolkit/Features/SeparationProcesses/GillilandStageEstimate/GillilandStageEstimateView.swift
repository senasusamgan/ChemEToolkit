import SwiftUI

struct GillilandStageEstimateView:
    View {

    @State private var minimumStagesInput = "6"
    @State private var minimumRefluxInput = "1.2"
    @State private var operatingRefluxInput = "1.8"

    @State private var result:
        GillilandStageEstimateResult?

    @State private var errorMessage = ""

    private let engine =
        GillilandStageEstimateEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.line.uptrend.xyaxis",
                    title: "Gilliland Stage Estimate",
                    subtitle: "Estimate theoretical stages at operating reflux",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("Use Fenske Nmin and a compatible minimum-reflux estimate from the same separation basis.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout
                            .calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title: "Minimum Theoretical Stages",
                            symbol: "Nmin",
                            unit: "stages",
                            placeholder: "6",
                            text: $minimumStagesInput
                        )

                        EngineeringInputField(
                            title: "Minimum Reflux Ratio",
                            symbol: "Rmin",
                            unit: "—",
                            placeholder: "1.2",
                            text: $minimumRefluxInput
                        )

                        EngineeringInputField(
                            title: "Operating Reflux Ratio",
                            symbol: "R",
                            unit: "—",
                            placeholder: "1.8",
                            text: $operatingRefluxInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage:
                                        "arrow.counterclockwise"
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
                            systemImage: "chart.line.uptrend.xyaxis",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Estimated Theoretical Stages",
                                        value: numberFormatter.format(result.estimatedTheoreticalStages),
                                        unit: "stages"
                                    ),
.init(
                                        label: "Stages Above Minimum",
                                        value: numberFormatter.format(result.stagesAboveMinimum),
                                        unit: "stages"
                                    ),
.init(
                                        label: "Gilliland X",
                                        value: numberFormatter.format(result.gillilandX),
                                        unit: "—"
                                    ),
.init(
                                        label: "Gilliland Y",
                                        value: numberFormatter.format(result.gillilandY),
                                        unit: "—"
                                    ),
.init(
                                        label: "R/Rmin",
                                        value: result.refluxMultipleOfMinimum.isFinite ? numberFormatter.format(result.refluxMultipleOfMinimum) : "Infinite",
                                        unit: "—"
                                    )
                                ],
                                tint: .purple
                            )

                            CalculatorInfoCard(tint: .purple) {
                                VStack(
                                    alignment: .leading,
                                    spacing: AppSpacing.small
                                ) {
                                    Text(result.modelName)
                                        .font(.headline)

                                    Divider()

                                    Text(
                                        result
                                            .limitationDescription
                                    )
                                    .foregroundStyle(.secondary)
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
                AppTheme.Layout
                    .pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout
                    .pageVerticalPadding
            )
        }
        .navigationTitle("Gilliland Stage Estimate")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    minimumTheoreticalStages:
                        try InputValidator.parseNumber(
                            minimumStagesInput,
                            fieldName:
                                "minimum theoretical stages"
                        ),
                    minimumRefluxRatio:
                        try InputValidator.parseNumber(
                            minimumRefluxInput,
                            fieldName:
                                "minimum reflux ratio"
                        ),
                    operatingRefluxRatio:
                        try InputValidator.parseNumber(
                            operatingRefluxInput,
                            fieldName:
                                "operating reflux ratio"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        minimumStagesInput = "6"
        minimumRefluxInput = "1.2"
        operatingRefluxInput = "1.8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        minimumStagesInput = ""
        minimumRefluxInput = ""
        operatingRefluxInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        GillilandStageEstimateView()
    }
}
