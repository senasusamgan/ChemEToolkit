import SwiftUI

struct BypassDeadVolumeReactorView:
    View {

    @State private var nominalVolumeInput =
        "10"

    @State private var flowRateInput =
        "1"

    @State private var deadFractionInput =
        "0.2"

    @State private var bypassFractionInput =
        "0.1"

    @State private var rateConstantInput =
        "0.2"

    @State private var result:
        BypassDeadVolumeReactorResult?

    @State private var errorMessage = ""

    private let engine =
        BypassDeadVolumeReactorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.triangle.pull",
                    title:
                        "Bypass–Dead-Volume Reactor",
                    subtitle:
                        "Estimate first-order conversion with short-circuiting and inaccessible volume",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Two-Path Nonideal Model")
                            .font(.headline)

                        Text(
                            "X_overall = (1−b)X_active"
                        )
                        .font(
                            .system(
                                size: 19,
                                weight: .semibold
                            )
                        )

                        Text(
                            "The active path is treated as an ideal PFR; bypassed material leaves unreacted."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
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
                            title:
                                "Nominal Reactor Volume",
                            symbol: "V",
                            unit: "m³",
                            placeholder: "10",
                            text:
                                $nominalVolumeInput
                        )

                        EngineeringInputField(
                            title:
                                "Total Volumetric Flow",
                            symbol: "Q",
                            unit: "m³/time",
                            placeholder: "1",
                            text: $flowRateInput
                        )

                        EngineeringInputField(
                            title:
                                "Dead-Volume Fraction",
                            symbol: "f_dead",
                            unit: "—",
                            placeholder: "0.2",
                            text:
                                $deadFractionInput
                        )

                        EngineeringInputField(
                            title:
                                "Bypass Fraction",
                            symbol: "b",
                            unit: "—",
                            placeholder: "0.1",
                            text:
                                $bypassFractionInput
                        )

                        EngineeringInputField(
                            title:
                                "First-Order Rate Constant",
                            symbol: "k",
                            unit: "1/time",
                            placeholder: "0.2",
                            text:
                                $rateConstantInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
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
                            title:
                                "Calculate Nonideal Conversion",
                            systemImage:
                                "arrow.triangle.pull",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Active Reactor Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .activeReactorVolume
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "Reactor-Path Flow",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .reactorPathFlowRate
                                                ),
                                            unit: "m³/time"
                                        ),
                                        .init(
                                            label:
                                                "Active-Path Space Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .activePathSpaceTime
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Active-Path Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .activePathConversion
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Overall Conversion",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .overallConversion
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Conversion Penalty",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionPenalty
                                                ),
                                            unit:
                                                "percentage points"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
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
        .navigationTitle("Bypass & Dead Volume")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    nominalReactorVolume:
                        try InputValidator.parseNumber(
                            nominalVolumeInput,
                            fieldName:
                                "nominal reactor volume"
                        ),
                    totalVolumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowRateInput,
                            fieldName:
                                "total volumetric flow rate"
                        ),
                    deadVolumeFraction:
                        try InputValidator.parseNumber(
                            deadFractionInput,
                            fieldName:
                                "dead-volume fraction"
                        ),
                    bypassFraction:
                        try InputValidator.parseNumber(
                            bypassFractionInput,
                            fieldName:
                                "bypass fraction"
                        ),
                    firstOrderRateConstant:
                        try InputValidator.parseNumber(
                            rateConstantInput,
                            fieldName:
                                "first-order rate constant"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        nominalVolumeInput = "10"
        flowRateInput = "1"
        deadFractionInput = "0.2"
        bypassFractionInput = "0.1"
        rateConstantInput = "0.2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        nominalVolumeInput = ""
        flowRateInput = ""
        deadFractionInput = ""
        bypassFractionInput = ""
        rateConstantInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BypassDeadVolumeReactorView()
    }
}
