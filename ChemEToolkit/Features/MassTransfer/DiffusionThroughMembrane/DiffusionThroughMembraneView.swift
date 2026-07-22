import SwiftUI

struct DiffusionThroughMembraneView:
    View {

    @State
    private var diffusivityInput =
        "0.0000000002"

    @State
    private var partitionCoefficientInput =
        "1.5"

    @State
    private var thicknessInput =
        "0.001"

    @State
    private var areaInput = "10"

    @State
    private var sideOneConcentrationInput =
        "100"

    @State
    private var sideTwoConcentrationInput =
        "20"

    @State
    private var result:
        DiffusionThroughMembraneResult?

    @State
    private var errorMessage = ""

    private let engine =
        DiffusionThroughMembraneEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "rectangle.portrait.fill",
                    title:
                        "Diffusion Through a Membrane",
                    subtitle:
                        "Calculate permeability, permeance, flux and transfer direction",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text(
                            "Homogeneous Membrane Transport"
                        )
                        .font(.headline)

                        Text(
                            "J = DK(C1 − C2)/L"
                        )
                        .font(
                            .system(
                                size: 20,
                                weight: .semibold
                            )
                        )

                        Text(
                            "P = DK, permeance = P/L"
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )

                        Text(
                            """
                            K is the dimensionless membrane/bulk partition \
                            coefficient. Positive flux is defined from side one \
                            toward side two.
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
            "Membrane Diffusion"
        )
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Membrane Properties")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Membrane Diffusivity",
                symbol: "D",
                unit: "m²/s",
                placeholder: "Example: 2e-10",
                text: $diffusivityInput
            )

            EngineeringInputField(
                title:
                    "Partition Coefficient",
                symbol: "K",
                unit: "—",
                placeholder: "Example: 1.5",
                text:
                    $partitionCoefficientInput
            )

            EngineeringInputField(
                title:
                    "Membrane Thickness",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 0.001",
                text: $thicknessInput
            )

            EngineeringInputField(
                title: "Membrane Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 10",
                text: $areaInput
            )

            Divider()

            Text("Bulk Concentrations")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Side-One Concentration",
                symbol: "C1",
                unit: "mol/m³",
                placeholder: "Example: 100",
                text:
                    $sideOneConcentrationInput
            )

            EngineeringInputField(
                title:
                    "Side-Two Concentration",
                symbol: "C2",
                unit: "mol/m³",
                placeholder: "Example: 20",
                text:
                    $sideTwoConcentrationInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Membrane Diffusion",
                systemImage:
                    "rectangle.portrait.fill",
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
            DiffusionThroughMembraneResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    .init(
                        label:
                            "Membrane Permeability",
                        value:
                            numberFormatter.format(
                                result
                                    .membranePermeability
                            ),
                        unit: "m²/s"
                    ),
                    .init(
                        label:
                            "Membrane Permeance",
                        value:
                            numberFormatter.format(
                                result
                                    .membranePermeance
                            ),
                        unit: "m/s"
                    ),
                    .init(
                        label:
                            "Membrane Resistance",
                        value:
                            numberFormatter.format(
                                result
                                    .membraneResistance
                            ),
                        unit: "s/m"
                    ),
                    .init(
                        label:
                            "Side-One Membrane Concentration",
                        value:
                            numberFormatter.format(
                                result
                                    .sideOneMembraneConcentration
                            ),
                        unit: "mol/m³ membrane"
                    ),
                    .init(
                        label:
                            "Side-Two Membrane Concentration",
                        value:
                            numberFormatter.format(
                                result
                                    .sideTwoMembraneConcentration
                            ),
                        unit: "mol/m³ membrane"
                    ),
                    .init(
                        label:
                            "Signed Molar Flux",
                        value:
                            numberFormatter.format(
                                result
                                    .signedMolarFlux
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    .init(
                        label:
                            "Transfer-Rate Magnitude",
                        value:
                            numberFormatter.format(
                                result
                                    .transferRateMagnitude
                            ),
                        unit: "mol/s"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Text(
                        result
                            .directionDescription
                    )
                    .font(.headline)

                    Divider()

                    Text(result.modelName)
                        .foregroundStyle(.secondary)

                    Text(
                        result
                            .limitationDescription
                    )
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
        -> DiffusionThroughMembraneInput {

        .init(
            diffusivityInMembrane:
                try InputValidator.parseNumber(
                    diffusivityInput,
                    fieldName:
                        "membrane diffusivity"
                ),
            partitionCoefficient:
                try InputValidator.parseNumber(
                    partitionCoefficientInput,
                    fieldName:
                        "partition coefficient"
                ),
            membraneThickness:
                try InputValidator.parseNumber(
                    thicknessInput,
                    fieldName:
                        "membrane thickness"
                ),
            membraneArea:
                try InputValidator.parseNumber(
                    areaInput,
                    fieldName:
                        "membrane area"
                ),
            sideOneConcentration:
                try InputValidator.parseNumber(
                    sideOneConcentrationInput,
                    fieldName:
                        "side-one concentration"
                ),
            sideTwoConcentration:
                try InputValidator.parseNumber(
                    sideTwoConcentrationInput,
                    fieldName:
                        "side-two concentration"
                )
        )
    }

    private func loadExample() {
        diffusivityInput = "0.0000000002"
        partitionCoefficientInput = "1.5"
        thicknessInput = "0.001"
        areaInput = "10"
        sideOneConcentrationInput = "100"
        sideTwoConcentrationInput = "20"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        diffusivityInput = ""
        partitionCoefficientInput = ""
        thicknessInput = ""
        areaInput = ""
        sideOneConcentrationInput = ""
        sideTwoConcentrationInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        DiffusionThroughMembraneView()
    }
}
