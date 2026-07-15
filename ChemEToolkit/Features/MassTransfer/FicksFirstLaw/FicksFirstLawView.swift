import SwiftUI

struct FicksFirstLawView: View {
    @State
    private var diffusivityInput = "0.00001"

    @State
    private var gradientInput = "-20"

    @State
    private var result: FicksFirstLawResult?

    @State
    private var errorMessage = ""

    private let engine =
        FicksFirstLawEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.left.and.right",
                    title: "Fick’s First Law",
                    subtitle:
                        "Calculate molecular diffusive flux from a concentration gradient",
                    tint: .blue
                )

                formulaCard

                CalculatorCard {
                    calculatorContent
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
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
        .navigationTitle("Fick’s First Law")
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text("Molecular Diffusion Flux")
                    .font(.headline)

                Text("Jₐ = −Dₐᵦ dcₐ/dz")
                    .font(
                        .system(
                            size: 23,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    The diffusive flux acts opposite to the \
                    concentration gradient. A positive result \
                    indicates transport in the positive coordinate direction.
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
            Text("Transport Inputs")
                .font(.headline)

            EngineeringInputField(
                title: "Binary Diffusivity",
                symbol: "Dₐᵦ",
                unit: "m²/s",
                placeholder: "Example: 0.00001",
                text: $diffusivityInput
            )

            EngineeringInputField(
                title: "Concentration Gradient",
                symbol: "dcₐ/dz",
                unit: "mol/m⁴",
                placeholder: "Example: -20",
                text: $gradientInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title: "Calculate Diffusive Flux",
                systemImage:
                    "arrow.left.and.right",
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
        _ result: FicksFirstLawResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "Molar Flux",
                        value:
                            numberFormatter.format(
                                result.molarFlux
                            ),
                        unit: "mol/(m²·s)"
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
                        "Transport Direction",
                        systemImage:
                            "arrow.left.and.right"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result.directionDescription
                    )
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
        -> FicksFirstLawInput {

        FicksFirstLawInput(
            diffusivity:
                try InputValidator.parseNumber(
                    diffusivityInput,
                    fieldName:
                        "binary diffusivity"
                ),
            concentrationGradient:
                try InputValidator.parseNumber(
                    gradientInput,
                    fieldName:
                        "concentration gradient"
                )
        )
    }

    private func loadExample() {
        diffusivityInput = "0.00001"
        gradientInput = "-20"
        clearResult()
    }

    private func resetInputs() {
        diffusivityInput = ""
        gradientInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FicksFirstLawView()
    }
}
