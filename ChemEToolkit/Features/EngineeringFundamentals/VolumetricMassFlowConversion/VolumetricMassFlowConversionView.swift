import SwiftUI

struct VolumetricMassFlowConversionView:
    View {

    @State private var flowInput = "10"
    @State private var densityInput = "1000"

    @State private var result:
        VolumetricMassFlowConversionResult?

    @State private var errorMessage = ""

    private let engine =
        VolumetricMassFlowConversionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.circle.fill",
                    title: "Volumetric Flow–Mass Flow",
                    subtitle: "Convert volumetric flow using density",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Density must represent the same stream state as the volumetric flow measurement.")
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
                            title: "Volumetric Flow Rate",
                            symbol: "Q",
                            unit: "m³/h",
                            placeholder: "10",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Density",
                            symbol: "ρ",
                            unit: "kg/m³",
                            placeholder: "1000",
                            text: $densityInput
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
                            systemImage: "drop.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Mass Flow Rate",
                                        value: numberFormatter.format(result.massFlowRateKilogramsPerHour),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Mass Flow Rate",
                                        value: numberFormatter.format(result.massFlowRateKilogramsPerSecond),
                                        unit: "kg/s"
                                    ),
.init(
                                        label: "Volumetric Flow Rate",
                                        value: numberFormatter.format(result.volumetricFlowRateCubicMetersPerSecond),
                                        unit: "m³/s"
                                    ),
.init(
                                        label: "Volumetric Flow Rate",
                                        value: numberFormatter.format(result.volumetricFlowRateLitersPerSecond),
                                        unit: "L/s"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
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
        .navigationTitle("Volumetric Flow–Mass Flow")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    volumetricFlowRateCubicMetersPerHour:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName:
                                "volumetric flow rate"
                        ),
                    densityKilogramsPerCubicMeter:
                        try InputValidator.parseNumber(
                            densityInput,
                            fieldName: "density"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        flowInput = "10"
        densityInput = "1000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        flowInput = ""
        densityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        VolumetricMassFlowConversionView()
    }
}
