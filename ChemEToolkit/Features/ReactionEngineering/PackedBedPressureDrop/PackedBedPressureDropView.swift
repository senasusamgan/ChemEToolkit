import SwiftUI

struct PackedBedPressureDropView:
    View {

    @State private var densityInput = "1.2"
    @State private var viscosityInput = "0.000018"
    @State private var velocityInput = "0.2"
    @State private var particleDiameterInput = "0.005"
    @State private var voidFractionInput = "0.4"
    @State private var bedLengthInput = "2"

    @State private var result:
        PackedBedPressureDropResult?

    @State private var errorMessage = ""

    private let engine =
        PackedBedPressureDropEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.down.to.line.compact",
                    title:
                        "Packed-Bed Pressure Drop",
                    subtitle:
                        "Calculate viscous and inertial Ergun contributions",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Ergun Equation")
                            .font(.headline)

                        Text(
                            "−dP/dL = viscous term + inertial term"
                        )
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )

                        Text(
                            "The calculation uses superficial velocity and bed void fraction."
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
                            title: "Fluid Density",
                            symbol: "ρ",
                            unit: "kg/m³",
                            placeholder: "Example: 1.2",
                            text: $densityInput
                        )

                        EngineeringInputField(
                            title: "Fluid Viscosity",
                            symbol: "μ",
                            unit: "Pa·s",
                            placeholder: "Example: 0.000018",
                            text: $viscosityInput
                        )

                        EngineeringInputField(
                            title: "Superficial Velocity",
                            symbol: "u",
                            unit: "m/s",
                            placeholder: "Example: 0.2",
                            text: $velocityInput
                        )

                        EngineeringInputField(
                            title: "Particle Diameter",
                            symbol: "d_p",
                            unit: "m",
                            placeholder: "Example: 0.005",
                            text:
                                $particleDiameterInput
                        )

                        EngineeringInputField(
                            title: "Bed Void Fraction",
                            symbol: "ε",
                            unit: "—",
                            placeholder: "Example: 0.4",
                            text: $voidFractionInput
                        )

                        EngineeringInputField(
                            title: "Bed Length",
                            symbol: "L",
                            unit: "m",
                            placeholder: "Example: 2",
                            text: $bedLengthInput
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
                                "Calculate Pressure Drop",
                            systemImage:
                                "arrow.down.to.line.compact",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Total Pressure Drop",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .totalPressureDrop
                                                ),
                                            unit: "Pa"
                                        ),
                                        .init(
                                            label:
                                                "Total Pressure Gradient",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .totalPressureGradient
                                                ),
                                            unit: "Pa/m"
                                        ),
                                        .init(
                                            label:
                                                "Viscous Pressure Drop",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .viscousPressureDrop
                                                ),
                                            unit: "Pa"
                                        ),
                                        .init(
                                            label:
                                                "Inertial Pressure Drop",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .inertialPressureDrop
                                                ),
                                            unit: "Pa"
                                        ),
                                        .init(
                                            label:
                                                "Particle Reynolds Number",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .particleReynoldsNumber
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Viscous Contribution",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .viscousContributionFraction
                                                ),
                                            unit: "%"
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
        .navigationTitle("Ergun Pressure Drop")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    fluidDensity:
                        try InputValidator.parseNumber(
                            densityInput,
                            fieldName:
                                "fluid density"
                        ),
                    fluidViscosity:
                        try InputValidator.parseNumber(
                            viscosityInput,
                            fieldName:
                                "fluid viscosity"
                        ),
                    superficialVelocity:
                        try InputValidator.parseNumber(
                            velocityInput,
                            fieldName:
                                "superficial velocity"
                        ),
                    particleDiameter:
                        try InputValidator.parseNumber(
                            particleDiameterInput,
                            fieldName:
                                "particle diameter"
                        ),
                    bedVoidFraction:
                        try InputValidator.parseNumber(
                            voidFractionInput,
                            fieldName:
                                "bed void fraction"
                        ),
                    bedLength:
                        try InputValidator.parseNumber(
                            bedLengthInput,
                            fieldName:
                                "bed length"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        densityInput = "1.2"
        viscosityInput = "0.000018"
        velocityInput = "0.2"
        particleDiameterInput = "0.005"
        voidFractionInput = "0.4"
        bedLengthInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        densityInput = ""
        viscosityInput = ""
        velocityInput = ""
        particleDiameterInput = ""
        voidFractionInput = ""
        bedLengthInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PackedBedPressureDropView()
    }
}
