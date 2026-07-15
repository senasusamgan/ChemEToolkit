import SwiftUI

struct EquimolarCounterDiffusionView: View {
    @State
    private var diffusivityInput = "0.00002"

    @State
    private var pressureInput = "101325"

    @State
    private var temperatureInput = "298.15"

    @State
    private var thicknessInput = "0.01"

    @State
    private var moleFractionOneInput = "0.8"

    @State
    private var moleFractionTwoInput = "0.2"

    @State
    private var result:
        EquimolarCounterDiffusionResult?

    @State
    private var errorMessage = ""

    private let engine =
        EquimolarCounterDiffusionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.left.arrow.right",
                    title:
                        "Equimolar Counter-Diffusion",
                    subtitle:
                        "Analyze equal and opposite component fluxes in a binary gas",
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
            "Equimolar Counter-Diffusion"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Binary Equimolar Diffusion"
                )
                .font(.headline)

                Text(
                    "Nₐ = −Nᵦ = DₐᵦC(yₐ,₁ − yₐ,₂)/L"
                )
                .font(
                    .system(
                        size: 18,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)
                .multilineTextAlignment(.center)

                Text("Nₐ + Nᵦ = 0")
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    Uses an ideal-gas binary mixture at constant \
                    pressure and temperature. Component fluxes \
                    are equal in magnitude and opposite in direction.
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
            Text("Gas Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Binary Diffusivity",
                symbol: "Dₐᵦ",
                unit: "m²/s",
                placeholder:
                    "Example: 0.00002",
                text: $diffusivityInput
            )

            EngineeringInputField(
                title: "Total Pressure",
                symbol: "P",
                unit: "Pa",
                placeholder:
                    "Example: 101325",
                text: $pressureInput
            )

            EngineeringInputField(
                title: "Temperature",
                symbol: "T",
                unit: "K",
                placeholder:
                    "Example: 298.15",
                text: $temperatureInput
            )

            Divider()

            Text("Film and Compositions")
                .font(.headline)

            EngineeringInputField(
                title: "Film Thickness",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 0.01",
                text: $thicknessInput
            )

            EngineeringInputField(
                title:
                    "Mole Fraction of A at Side 1",
                symbol: "yₐ,₁",
                unit: "—",
                placeholder: "Example: 0.8",
                text:
                    $moleFractionOneInput
            )

            EngineeringInputField(
                title:
                    "Mole Fraction of A at Side 2",
                symbol: "yₐ,₂",
                unit: "—",
                placeholder: "Example: 0.2",
                text:
                    $moleFractionTwoInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Counter-Diffusion",
                systemImage:
                    "arrow.left.arrow.right",
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
            EquimolarCounterDiffusionResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "Flux of A",
                        value:
                            numberFormatter.format(
                                result.fluxA
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    CalculationResultDisplayItem(
                        label: "Flux of B",
                        value:
                            numberFormatter.format(
                                result.fluxB
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Molar Flux",
                        value:
                            numberFormatter.format(
                                result.totalMolarFlux
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Molar Concentration",
                        value:
                            numberFormatter.format(
                                result
                                    .totalMolarConcentration
                            ),
                        unit: "mol/m³"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
                Label(
                    "The component fluxes sum to zero under the equimolar counter-diffusion assumption.",
                    systemImage:
                        "arrow.left.arrow.right"
                )
                .foregroundStyle(.secondary)
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
        -> EquimolarCounterDiffusionInput {

        EquimolarCounterDiffusionInput(
            diffusivity:
                try InputValidator.parseNumber(
                    diffusivityInput,
                    fieldName:
                        "binary diffusivity"
                ),
            totalPressure:
                try InputValidator.parseNumber(
                    pressureInput,
                    fieldName:
                        "total pressure"
                ),
            temperature:
                try InputValidator.parseNumber(
                    temperatureInput,
                    fieldName: "temperature"
                ),
            thickness:
                try InputValidator.parseNumber(
                    thicknessInput,
                    fieldName:
                        "film thickness"
                ),
            moleFractionAAtSideOne:
                try InputValidator.parseNumber(
                    moleFractionOneInput,
                    fieldName:
                        "mole fraction at side 1"
                ),
            moleFractionAAtSideTwo:
                try InputValidator.parseNumber(
                    moleFractionTwoInput,
                    fieldName:
                        "mole fraction at side 2"
                )
        )
    }

    private func loadExample() {
        diffusivityInput = "0.00002"
        pressureInput = "101325"
        temperatureInput = "298.15"
        thicknessInput = "0.01"
        moleFractionOneInput = "0.8"
        moleFractionTwoInput = "0.2"
        clearResult()
    }

    private func resetInputs() {
        diffusivityInput = ""
        pressureInput = ""
        temperatureInput = ""
        thicknessInput = ""
        moleFractionOneInput = ""
        moleFractionTwoInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EquimolarCounterDiffusionView()
    }
}
