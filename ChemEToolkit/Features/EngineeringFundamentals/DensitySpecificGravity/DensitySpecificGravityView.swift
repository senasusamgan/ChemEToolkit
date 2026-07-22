import SwiftUI

struct DensitySpecificGravityView:
    View {

    @State private var massInput = "1200"
    @State private var volumeInput = "1.5"
    @State private var referenceInput = "1000"

    @State private var result:
        DensitySpecificGravityResult?

    @State private var errorMessage = ""

    private let engine =
        DensitySpecificGravityEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "scalemass.fill",
                    title: "Density & Specific Gravity",
                    subtitle: "Calculate density, specific gravity and specific volume",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Use a reference density of 1000 kg/m³ for water-based specific gravity.")
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
                            title: "Mass",
                            symbol: "m",
                            unit: "kg",
                            placeholder: "1200",
                            text: $massInput
                        )

                        EngineeringInputField(
                            title: "Volume",
                            symbol: "V",
                            unit: "m³",
                            placeholder: "1.5",
                            text: $volumeInput
                        )

                        EngineeringInputField(
                            title: "Reference Density",
                            symbol: "ρ_ref",
                            unit: "kg/m³",
                            placeholder: "1000",
                            text: $referenceInput
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
                            systemImage: "scalemass.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Density",
                                        value: numberFormatter.format(result.density),
                                        unit: "kg/m³"
                                    ),
.init(
                                        label: "Specific Gravity",
                                        value: numberFormatter.format(result.specificGravity),
                                        unit: "—"
                                    ),
.init(
                                        label: "Specific Volume",
                                        value: result.specificVolume.isFinite ? numberFormatter.format(result.specificVolume) : "Infinite",
                                        unit: "m³/kg"
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
        .navigationTitle("Density & Specific Gravity")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    mass:
                        try InputValidator.parseNumber(
                            massInput,
                            fieldName: "mass"
                        ),
                    volume:
                        try InputValidator.parseNumber(
                            volumeInput,
                            fieldName: "volume"
                        ),
                    referenceDensity:
                        try InputValidator.parseNumber(
                            referenceInput,
                            fieldName:
                                "reference density"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        massInput = "1200"
        volumeInput = "1.5"
        referenceInput = "1000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        massInput = ""
        volumeInput = ""
        referenceInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        DensitySpecificGravityView()
    }
}
