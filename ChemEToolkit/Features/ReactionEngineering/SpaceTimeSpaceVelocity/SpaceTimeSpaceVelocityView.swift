import SwiftUI

struct SpaceTimeSpaceVelocityView:
    View {

    @State private var reactorVolumeInput = "5"
    @State private var flowRateInput = "0.002"
    @State private var holdupFractionInput = "0.4"

    @State private var result:
        SpaceTimeSpaceVelocityResult?

    @State private var errorMessage = ""

    private let engine =
        SpaceTimeSpaceVelocityEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "clock.arrow.circlepath",
                    title: "Space Time & Space Velocity",
                    subtitle:
                        "Calculate nominal reactor time, LHSV and fluid-holdup time",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Flow-Based Reactor Metrics")
                            .font(.headline)

                        Text("τ = V/v₀,  SV = v₀/V")
                            .font(
                                .system(
                                    size: 20,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "The holdup calculation uses εV as the fluid-occupied volume."
                        )
                        .foregroundStyle(.secondary)
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
                            title: "Reactor Volume",
                            symbol: "V",
                            unit: "m³",
                            placeholder: "Example: 5",
                            text: $reactorVolumeInput
                        )

                        EngineeringInputField(
                            title:
                                "Inlet Volumetric Flow Rate",
                            symbol: "v₀",
                            unit: "m³/s",
                            placeholder: "Example: 0.002",
                            text: $flowRateInput
                        )

                        EngineeringInputField(
                            title:
                                "Fluid Holdup Fraction",
                            symbol: "ε",
                            unit: "—",
                            placeholder: "Example: 0.4",
                            text: $holdupFractionInput
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
                                "Calculate Flow Metrics",
                            systemImage:
                                "clock.arrow.circlepath",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Space Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .spaceTimeSeconds
                                                ),
                                            unit: "s"
                                        ),
                                        .init(
                                            label:
                                                "Space Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .spaceTimeHours
                                                ),
                                            unit: "h"
                                        ),
                                        .init(
                                            label:
                                                "Space Velocity",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .spaceVelocityPerHour
                                                ),
                                            unit: "h⁻¹"
                                        ),
                                        .init(
                                            label:
                                                "Fluid Holdup Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .fluidHoldupVolume
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "Holdup Residence Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .fluidHoldupResidenceTimeSeconds
                                                ),
                                            unit: "s"
                                        ),
                                        .init(
                                            label:
                                                "Interstitial Space Velocity",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .interstitialSpaceVelocityPerHour
                                                ),
                                            unit: "h⁻¹"
                                        ),
                                        .init(
                                            label:
                                                "Reactor Volumes per Day",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .reactorVolumesProcessedPerDay
                                                ),
                                            unit: "day⁻¹"
                                        ),
                                        .init(
                                            label:
                                                "Daily Throughput",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .dailyVolumetricThroughput
                                                ),
                                            unit: "m³/day"
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
        .navigationTitle("Space Time")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    reactorVolume:
                        try InputValidator.parseNumber(
                            reactorVolumeInput,
                            fieldName:
                                "reactor volume"
                        ),
                    inletVolumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowRateInput,
                            fieldName:
                                "inlet volumetric flow rate"
                        ),
                    fluidHoldupFraction:
                        try InputValidator.parseNumber(
                            holdupFractionInput,
                            fieldName:
                                "fluid holdup fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        reactorVolumeInput = "5"
        flowRateInput = "0.002"
        holdupFractionInput = "0.4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        reactorVolumeInput = ""
        flowRateInput = ""
        holdupFractionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SpaceTimeSpaceVelocityView()
    }
}
