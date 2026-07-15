import SwiftUI

struct SteadyStateDiffusionView: View {
    @State
    private var diffusivityInput = "0.00001"

    @State
    private var areaInput = "0.5"

    @State
    private var thicknessInput = "0.01"

    @State
    private var concentrationOneInput = "2"

    @State
    private var concentrationTwoInput = "0.5"

    @State
    private var result:
        SteadyStateDiffusionResult?

    @State
    private var errorMessage = ""

    private let engine =
        SteadyStateDiffusionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "rectangle.split.3x1",
                    title:
                        "Steady-State Diffusion",
                    subtitle:
                        "Calculate planar diffusion flux, rate and concentration profile",
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
            "Steady-State Diffusion"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text("Planar Diffusion")
                    .font(.headline)

                Text(
                    "Nₐ = Dₐᵦ(cₐ,₁ − cₐ,₂)/L"
                )
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )
                .multilineTextAlignment(.center)

                Text("ṅₐ = NₐA")
                    .font(
                        .system(
                            size: 19,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    Assumes steady one-dimensional diffusion through \
                    a planar layer with constant area, constant \
                    diffusivity and no chemical reaction.
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
            Text("Transport and Geometry")
                .font(.headline)

            EngineeringInputField(
                title: "Diffusivity",
                symbol: "Dₐᵦ",
                unit: "m²/s",
                placeholder:
                    "Example: 0.00001",
                text: $diffusivityInput
            )

            EngineeringInputField(
                title: "Transfer Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 0.5",
                text: $areaInput
            )

            EngineeringInputField(
                title: "Layer Thickness",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 0.01",
                text: $thicknessInput
            )

            Divider()

            Text("Boundary Concentrations")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Concentration at Side 1",
                symbol: "cₐ,₁",
                unit: "mol/m³",
                placeholder: "Example: 2",
                text:
                    $concentrationOneInput
            )

            EngineeringInputField(
                title:
                    "Concentration at Side 2",
                symbol: "cₐ,₂",
                unit: "mol/m³",
                placeholder: "Example: 0.5",
                text:
                    $concentrationTwoInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Steady Diffusion",
                systemImage:
                    "rectangle.split.3x1",
                action: calculate
            )

            if let result {
                CalculationResultCard(
                    items: [
                        CalculationResultDisplayItem(
                            label: "Molar Flux",
                            value:
                                numberFormatter
                                    .format(
                                        result
                                            .molarFlux
                                    ),
                            unit: "mol/(m²·s)"
                        ),
                        CalculationResultDisplayItem(
                            label: "Molar Rate",
                            value:
                                numberFormatter
                                    .format(
                                        result
                                            .molarRate
                                    ),
                            unit: "mol/s"
                        ),
                        CalculationResultDisplayItem(
                            label:
                                "Midpoint Concentration",
                            value:
                                numberFormatter
                                    .format(
                                        result
                                            .midpointConcentration
                                    ),
                            unit: "mol/m³"
                        )
                    ],
                    tint: .blue
                )
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
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
        -> SteadyStateDiffusionInput {

        SteadyStateDiffusionInput(
            diffusivity:
                try InputValidator.parseNumber(
                    diffusivityInput,
                    fieldName: "diffusivity"
                ),
            area:
                try InputValidator.parseNumber(
                    areaInput,
                    fieldName:
                        "transfer area"
                ),
            thickness:
                try InputValidator.parseNumber(
                    thicknessInput,
                    fieldName:
                        "layer thickness"
                ),
            concentrationAtSideOne:
                try InputValidator.parseNumber(
                    concentrationOneInput,
                    fieldName:
                        "concentration at side 1"
                ),
            concentrationAtSideTwo:
                try InputValidator.parseNumber(
                    concentrationTwoInput,
                    fieldName:
                        "concentration at side 2"
                )
        )
    }

    private func loadExample() {
        diffusivityInput = "0.00001"
        areaInput = "0.5"
        thicknessInput = "0.01"
        concentrationOneInput = "2"
        concentrationTwoInput = "0.5"
        clearResult()
    }

    private func resetInputs() {
        diffusivityInput = ""
        areaInput = ""
        thicknessInput = ""
        concentrationOneInput = ""
        concentrationTwoInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SteadyStateDiffusionView()
    }
}
