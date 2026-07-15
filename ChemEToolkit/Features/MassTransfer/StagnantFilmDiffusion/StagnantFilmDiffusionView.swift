import SwiftUI

struct StagnantFilmDiffusionView: View {
    @State
    private var diffusivityInput = "0.00002"

    @State
    private var pressureInput = "101325"

    @State
    private var temperatureInput = "298.15"

    @State
    private var thicknessInput = "0.01"

    @State
    private var moleFractionOneInput = "0.4"

    @State
    private var moleFractionTwoInput = "0.1"

    @State
    private var result:
        StagnantFilmDiffusionResult?

    @State
    private var errorMessage = ""

    private let engine =
        StagnantFilmDiffusionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "wind",
                    title:
                        "Stagnant-Film Diffusion",
                    subtitle:
                        "Calculate Stefan diffusion through a non-diffusing gas component",
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
            "Stagnant-Film Diffusion"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Stefan Diffusion Through Stagnant B"
                )
                .font(.headline)

                Text(
                    "Nₐ = DₐᵦC(yₐ,₁ − yₐ,₂)/(L yᵦ,ₗₘ)"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)
                .multilineTextAlignment(.center)

                Text("Nᵦ = 0")
                    .font(
                        .system(
                            size: 20,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    Applies to steady one-dimensional transport in \
                    an ideal binary gas when component B has zero \
                    molar flux across the film.
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
                placeholder: "Example: 0.4",
                text:
                    $moleFractionOneInput
            )

            EngineeringInputField(
                title:
                    "Mole Fraction of A at Side 2",
                symbol: "yₐ,₂",
                unit: "—",
                placeholder: "Example: 0.1",
                text:
                    $moleFractionTwoInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Stefan Diffusion",
                systemImage: "wind",
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
            StagnantFilmDiffusionResult
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
                        label:
                            "Log-Mean Inert Fraction",
                        value:
                            numberFormatter.format(
                                result
                                    .logMeanInertFraction
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
                        systemImage: "wind"
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
        -> StagnantFilmDiffusionInput {

        StagnantFilmDiffusionInput(
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
        moleFractionOneInput = "0.4"
        moleFractionTwoInput = "0.1"
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
        StagnantFilmDiffusionView()
    }
}
