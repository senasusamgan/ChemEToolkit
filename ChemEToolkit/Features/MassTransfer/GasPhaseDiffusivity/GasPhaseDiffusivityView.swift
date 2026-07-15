import SwiftUI

struct GasPhaseDiffusivityView: View {
    @State
    private var referenceDiffusivityInput =
        "0.000018"

    @State
    private var referenceTemperatureInput =
        "298.15"

    @State
    private var referencePressureInput =
        "101325"

    @State
    private var targetTemperatureInput =
        "350"

    @State
    private var targetPressureInput =
        "202650"

    @State
    private var result:
        GasPhaseDiffusivityResult?

    @State
    private var errorMessage = ""

    private let engine =
        GasPhaseDiffusivityEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "cloud.fill",
                    title:
                        "Gas-Phase Diffusivity",
                    subtitle:
                        "Scale a known binary gas diffusivity to a new temperature and pressure",
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
            "Gas-Phase Diffusivity"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Temperature–Pressure Scaling"
                )
                .font(.headline)

                Text(
                    "D₂ = D₁(T₂/T₁)¹·⁷⁵(P₁/P₂)"
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
                    Intended for dilute, low-pressure binary gases \
                    when a reliable reference diffusivity is known. \
                    Temperatures and pressures must be absolute.
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
                    "Example: 0.000018",
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
                    "Reference Pressure",
                symbol: "P₁",
                unit: "Pa",
                placeholder:
                    "Example: 101325",
                text:
                    $referencePressureInput
            )

            Divider()

            Text("Target State")
                .font(.headline)

            EngineeringInputField(
                title: "Target Temperature",
                symbol: "T₂",
                unit: "K",
                placeholder: "Example: 350",
                text:
                    $targetTemperatureInput
            )

            EngineeringInputField(
                title: "Target Pressure",
                symbol: "P₂",
                unit: "Pa",
                placeholder:
                    "Example: 202650",
                text:
                    $targetPressureInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Gas Diffusivity",
                systemImage: "cloud.fill",
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
        _ result: GasPhaseDiffusivityResult
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
                            "Pressure Factor",
                        value:
                            numberFormatter.format(
                                result
                                    .pressureCorrectionFactor
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
                        systemImage: "cloud.fill"
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
        -> GasPhaseDiffusivityInput {

        GasPhaseDiffusivityInput(
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
            referencePressure:
                try InputValidator.parseNumber(
                    referencePressureInput,
                    fieldName:
                        "reference pressure"
                ),
            targetTemperature:
                try InputValidator.parseNumber(
                    targetTemperatureInput,
                    fieldName:
                        "target temperature"
                ),
            targetPressure:
                try InputValidator.parseNumber(
                    targetPressureInput,
                    fieldName:
                        "target pressure"
                )
        )
    }

    private func loadExample() {
        referenceDiffusivityInput =
            "0.000018"
        referenceTemperatureInput =
            "298.15"
        referencePressureInput =
            "101325"
        targetTemperatureInput = "350"
        targetPressureInput = "202650"
        clearResult()
    }

    private func resetInputs() {
        referenceDiffusivityInput = ""
        referenceTemperatureInput = ""
        referencePressureInput = ""
        targetTemperatureInput = ""
        targetPressureInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        GasPhaseDiffusivityView()
    }
}
