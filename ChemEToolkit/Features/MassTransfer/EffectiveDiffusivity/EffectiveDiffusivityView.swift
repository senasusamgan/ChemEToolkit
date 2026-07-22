import SwiftUI

struct EffectiveDiffusivityView: View {
    @State private var molecularDiffusivityInput =
        "0.000000001"
    @State private var knudsenDiffusivityInput =
        "0.000000005"
    @State private var porosityInput = "0.4"
    @State private var tortuosityInput = "2.5"
    @State private var constrictivityInput = "0.8"

    @State private var result:
        EffectiveDiffusivityResult?

    @State private var errorMessage = ""

    private let engine =
        EffectiveDiffusivityEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "circle.hexagongrid.fill",
                    title: "Effective Diffusivity",
                    subtitle:
                        "Correct molecular and Knudsen diffusion for porous-medium structure",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Porous-Medium Diffusion")
                            .font(.headline)

                        Text(
                            "Deff = (εδ/τ)[1/Dm + 1/DK]⁻¹"
                        )
                        .font(
                            .system(
                                size: 18,
                                weight: .semibold
                            )
                        )
                        .minimumScaleFactor(0.5)

                        Text(
                            "ε is porosity, τ tortuosity and δ constrictivity. Molecular and Knudsen resistances are combined using the Bosanquet relation."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout.calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        Text("Pore Diffusivities")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Molecular Diffusivity",
                            symbol: "Dm",
                            unit: "m²/s",
                            placeholder: "Example: 1e-9",
                            text: $molecularDiffusivityInput
                        )

                        EngineeringInputField(
                            title: "Knudsen Diffusivity",
                            symbol: "DK",
                            unit: "m²/s",
                            placeholder: "Example: 5e-9",
                            text: $knudsenDiffusivityInput
                        )

                        Divider()

                        Text("Porous Structure")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Porosity",
                            symbol: "ε",
                            unit: "—",
                            placeholder: "Example: 0.4",
                            text: $porosityInput
                        )

                        EngineeringInputField(
                            title: "Tortuosity",
                            symbol: "τ",
                            unit: "—",
                            placeholder: "Example: 2.5",
                            text: $tortuosityInput
                        )

                        EngineeringInputField(
                            title: "Constrictivity",
                            symbol: "δ",
                            unit: "—",
                            placeholder: "Example: 0.8",
                            text: $constrictivityInput
                        )

                        MassTransferActionButtons(
                            loadExample: loadExample,
                            clear: resetInputs
                        )

                        PrimaryActionButton(
                            title: "Calculate Effective Diffusivity",
                            systemImage:
                                "circle.hexagongrid.fill",
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
            }
            .frame(maxWidth: .infinity)
            .padding(
                .horizontal,
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Effective Diffusivity")
    }

    private func resultSection(
        _ result: EffectiveDiffusivityResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    .init(
                        label: "Porous Correction Factor",
                        value: numberFormatter.format(
                            result.porousMediumCorrectionFactor
                        ),
                        unit: "—"
                    ),
                    .init(
                        label: "Effective Molecular Diffusivity",
                        value: numberFormatter.format(
                            result.effectiveMolecularDiffusivity
                        ),
                        unit: "m²/s"
                    ),
                    .init(
                        label: "Bosanquet Pore Diffusivity",
                        value: numberFormatter.format(
                            result.bosanquetPoreDiffusivity
                        ),
                        unit: "m²/s"
                    ),
                    .init(
                        label: "Effective Combined Diffusivity",
                        value: numberFormatter.format(
                            result.effectiveCombinedDiffusivity
                        ),
                        unit: "m²/s"
                    ),
                    .init(
                        label: "Molecular Resistance Share",
                        value: numberFormatter.format(
                            100 * result.molecularResistanceFraction
                        ),
                        unit: "%"
                    ),
                    .init(
                        label: "Knudsen Resistance Share",
                        value: numberFormatter.format(
                            100 * result.knudsenResistanceFraction
                        ),
                        unit: "%"
                    ),
                    .init(
                        label: "Reduction vs Molecular D",
                        value: numberFormatter.format(
                            100 * result.reductionRelativeToMolecularDiffusivity
                        ),
                        unit: "%"
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

                    Text(result.limitationDescription)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func calculate() {
        result = nil
        errorMessage = ""

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
        -> EffectiveDiffusivityInput {

        .init(
            molecularDiffusivity:
                try InputValidator.parseNumber(
                    molecularDiffusivityInput,
                    fieldName: "molecular diffusivity"
                ),
            knudsenDiffusivity:
                try InputValidator.parseNumber(
                    knudsenDiffusivityInput,
                    fieldName: "Knudsen diffusivity"
                ),
            porosity:
                try InputValidator.parseNumber(
                    porosityInput,
                    fieldName: "porosity"
                ),
            tortuosity:
                try InputValidator.parseNumber(
                    tortuosityInput,
                    fieldName: "tortuosity"
                ),
            constrictivity:
                try InputValidator.parseNumber(
                    constrictivityInput,
                    fieldName: "constrictivity"
                )
        )
    }

    private func loadExample() {
        molecularDiffusivityInput = "0.000000001"
        knudsenDiffusivityInput = "0.000000005"
        porosityInput = "0.4"
        tortuosityInput = "2.5"
        constrictivityInput = "0.8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        molecularDiffusivityInput = ""
        knudsenDiffusivityInput = ""
        porosityInput = ""
        tortuosityInput = ""
        constrictivityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EffectiveDiffusivityView()
    }
}
