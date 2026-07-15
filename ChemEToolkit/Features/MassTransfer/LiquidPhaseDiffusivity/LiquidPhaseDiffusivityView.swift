import SwiftUI

struct LiquidPhaseDiffusivityView: View {
    @State
    private var referenceDiffusivityInput =
        "0.000000001"

    @State
    private var referenceTemperatureInput =
        "298.15"

    @State
    private var referenceViscosityInput =
        "0.001"

    @State
    private var targetTemperatureInput =
        "310"

    @State
    private var targetViscosityInput =
        "0.0008"

    @State
    private var result:
        LiquidPhaseDiffusivityResult?

    @State
    private var errorMessage = ""

    private let engine =
        LiquidPhaseDiffusivityEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.fill",
                    title:
                        "Liquid-Phase Diffusivity",
                    subtitle:
                        "Scale a known dilute-solution diffusivity using temperature and viscosity",
                    tint: .blue
                )

                formulaCard

                CalculatorCard {
                    calculatorContent
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
        .navigationTitle(
            "Liquid-Phase Diffusivity"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Temperature–Viscosity Scaling"
                )
                .font(.headline)

                Text(
                    "D₂ = D₁(T₂/T₁)(μ₁/μ₂)"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.6)
                .multilineTextAlignment(.center)

                Text(
                    """
                    Uses the Stokes–Einstein proportionality for \
                    the same dilute solute–solvent pair. Absolute \
                    temperature and dynamic viscosity are required.
                    """
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
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Reference State")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Reference Diffusivity",
                symbol: "D₁",
                unit: "m²/s",
                placeholder:
                    "Example: 0.000000001",
                text:
                    $referenceDiffusivityInput
            )

            EngineeringInputField(
                title:
                    "Reference Temperature",
                symbol: "T₁",
                unit: "K",
                placeholder:
                    "Example: 298.15",
                text:
                    $referenceTemperatureInput
            )

            EngineeringInputField(
                title:
                    "Reference Viscosity",
                symbol: "μ₁",
                unit: "Pa·s",
                placeholder:
                    "Example: 0.001",
                text:
                    $referenceViscosityInput
            )

            Divider()

            Text("Target State")
                .font(.headline)

            EngineeringInputField(
                title: "Target Temperature",
                symbol: "T₂",
                unit: "K",
                placeholder: "Example: 310",
                text:
                    $targetTemperatureInput
            )

            EngineeringInputField(
                title: "Target Viscosity",
                symbol: "μ₂",
                unit: "Pa·s",
                placeholder:
                    "Example: 0.0008",
                text:
                    $targetViscosityInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Liquid Diffusivity",
                systemImage: "drop.fill",
                action: calculate
            )

            if let result {
                resultSection(result)
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private func resultSection(
        _ result:
            LiquidPhaseDiffusivityResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Target Diffusivity",
                        value:
                            numberFormatter.format(
                                result
                                    .targetDiffusivity
                            ),
                        unit: "m²/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Temperature Factor",
                        value:
                            numberFormatter.format(
                                result
                                    .temperatureCorrectionFactor
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Viscosity Factor",
                        value:
                            numberFormatter.format(
                                result
                                    .viscosityCorrectionFactor
                            ),
                        unit: "—"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Label(
                        "Applied Model",
                        systemImage: "drop.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(result.modelName)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                try makeInput()
            )
        } catch {
            errorMessage =
                MassTransferViewSupport
                    .errorMessage(for: error)
        }
    }

    private func makeInput() throws
        -> LiquidPhaseDiffusivityInput {

        LiquidPhaseDiffusivityInput(
            referenceDiffusivity:
                try InputValidator.parseNumber(
                    referenceDiffusivityInput,
                    fieldName:
                        "reference diffusivity"
                ),
            referenceTemperature:
                try InputValidator.parseNumber(
                    referenceTemperatureInput,
                    fieldName:
                        "reference temperature"
                ),
            referenceViscosity:
                try InputValidator.parseNumber(
                    referenceViscosityInput,
                    fieldName:
                        "reference viscosity"
                ),
            targetTemperature:
                try InputValidator.parseNumber(
                    targetTemperatureInput,
                    fieldName:
                        "target temperature"
                ),
            targetViscosity:
                try InputValidator.parseNumber(
                    targetViscosityInput,
                    fieldName:
                        "target viscosity"
                )
        )
    }

    private func loadExample() {
        referenceDiffusivityInput =
            "0.000000001"
        referenceTemperatureInput =
            "298.15"
        referenceViscosityInput =
            "0.001"
        targetTemperatureInput = "310"
        targetViscosityInput =
            "0.0008"
        clearResult()
    }

    private func resetInputs() {
        referenceDiffusivityInput = ""
        referenceTemperatureInput = ""
        referenceViscosityInput = ""
        targetTemperatureInput = ""
        targetViscosityInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LiquidPhaseDiffusivityView()
    }
}
