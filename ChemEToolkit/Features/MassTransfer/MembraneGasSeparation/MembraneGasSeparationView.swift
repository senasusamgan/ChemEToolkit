import SwiftUI

struct MembraneGasSeparationView:
    View {

    @State
    private var feedFlowInput = "1"

    @State
    private var membraneAreaInput = "10"

    @State
    private var feedPressureInput = "10"

    @State
    private var permeatePressureInput = "1"

    @State
    private var feedCompositionInput = "0.2"

    @State
    private var fastPermeanceInput = "100"

    @State
    private var slowPermeanceInput = "10"

    @State
    private var result:
        MembraneGasSeparationResult?

    @State
    private var errorMessage = ""

    private let engine =
        MembraneGasSeparationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "square.split.2x1.fill",
                    title:
                        "Membrane Gas Separation",
                    subtitle:
                        "Calculate binary permeation fluxes, purity, stage cut and recovery",
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
            "Membrane Gas Separation"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Solution–Diffusion Permeation"
                )
                .font(.headline)

                Text(
                    "Ji = Πi(xi Pf − yi Pp)"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )

                Text(
                    "yi = Ji / ΣJ"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )

                Text(
                    """
                    Permeate composition is solved self-consistently. \
                    Feed-side composition is treated as constant, so the \
                    engine restricts results to stage cut ≤ 0.20.
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
            Text("Flow and Membrane Area")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Feed Molar Flow",
                symbol: "F",
                unit: "mol/s",
                placeholder: "Example: 1",
                text: $feedFlowInput
            )

            EngineeringInputField(
                title: "Membrane Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 10",
                text: $membraneAreaInput
            )

            Divider()

            Text("Pressure and Feed Composition")
                .font(.headline)

            EngineeringInputField(
                title: "Feed Pressure",
                symbol: "Pf",
                unit: "bar",
                placeholder: "Example: 10",
                text: $feedPressureInput
            )

            EngineeringInputField(
                title:
                    "Permeate Pressure",
                symbol: "Pp",
                unit: "bar",
                placeholder: "Example: 1",
                text:
                    $permeatePressureInput
            )

            EngineeringInputField(
                title:
                    "Feed Fast-Component Fraction",
                symbol: "zA",
                unit: "—",
                placeholder: "Example: 0.2",
                text: $feedCompositionInput
            )

            Divider()

            Text("Component Permeances")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Fast-Component Permeance",
                symbol: "ΠA",
                unit: "GPU",
                placeholder: "Example: 100",
                text: $fastPermeanceInput
            )

            EngineeringInputField(
                title:
                    "Slow-Component Permeance",
                symbol: "ΠB",
                unit: "GPU",
                placeholder: "Example: 10",
                text: $slowPermeanceInput
            )

            CalculatorInfoCard(tint: .orange) {
                Label(
                    "This is a low-stage-cut binary screening model, not a full concentration-polarization or module-flow simulation.",
                    systemImage:
                        "exclamationmark.triangle.fill"
                )
                .foregroundStyle(.secondary)
            }

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Membrane Separation",
                systemImage:
                    "square.split.2x1.fill",
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
            MembraneGasSeparationResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Ideal Selectivity",
                        value:
                            numberFormatter.format(
                                result.idealSelectivity
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Permeate Fast Fraction",
                        value:
                            numberFormatter.format(
                                result
                                    .permeateFastComponentMoleFraction
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Retentate Fast Fraction",
                        value:
                            numberFormatter.format(
                                result
                                    .retentateFastComponentMoleFraction
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Fast-Component Flux",
                        value:
                            numberFormatter.format(
                                result
                                    .fastComponentFlux
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Slow-Component Flux",
                        value:
                            numberFormatter.format(
                                result
                                    .slowComponentFlux
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
                            "Permeate Flow",
                        value:
                            numberFormatter.format(
                                result
                                    .permeateMolarFlowRate
                            ),
                        unit: "mol/s"
                    ),
                    CalculationResultDisplayItem(
                        label: "Stage Cut",
                        value:
                            numberFormatter.format(
                                100 * result.stageCut
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Fast-Component Recovery",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .fastComponentRecovery
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Purity Increase",
                        value:
                            numberFormatter.format(
                                result.purityIncrease
                            ),
                        unit: "mole fraction"
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
                        "Model Validity",
                        systemImage:
                            "square.split.2x1.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result
                            .validityDescription
                    )
                    .fontWeight(.semibold)

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
        -> MembraneGasSeparationInput {

        MembraneGasSeparationInput(
            feedMolarFlowRate:
                try InputValidator.parseNumber(
                    feedFlowInput,
                    fieldName:
                        "feed molar flow"
                ),
            membraneArea:
                try InputValidator.parseNumber(
                    membraneAreaInput,
                    fieldName:
                        "membrane area"
                ),
            feedPressureBar:
                try InputValidator.parseNumber(
                    feedPressureInput,
                    fieldName:
                        "feed pressure"
                ),
            permeatePressureBar:
                try InputValidator.parseNumber(
                    permeatePressureInput,
                    fieldName:
                        "permeate pressure"
                ),
            feedFastComponentMoleFraction:
                try InputValidator.parseNumber(
                    feedCompositionInput,
                    fieldName:
                        "feed fast-component fraction"
                ),
            fastComponentPermeanceGPU:
                try InputValidator.parseNumber(
                    fastPermeanceInput,
                    fieldName:
                        "fast-component permeance"
                ),
            slowComponentPermeanceGPU:
                try InputValidator.parseNumber(
                    slowPermeanceInput,
                    fieldName:
                        "slow-component permeance"
                )
        )
    }

    private func loadExample() {
        feedFlowInput = "1"
        membraneAreaInput = "10"
        feedPressureInput = "10"
        permeatePressureInput = "1"
        feedCompositionInput = "0.2"
        fastPermeanceInput = "100"
        slowPermeanceInput = "10"
        clearResult()
    }

    private func resetInputs() {
        feedFlowInput = ""
        membraneAreaInput = ""
        feedPressureInput = ""
        permeatePressureInput = ""
        feedCompositionInput = ""
        fastPermeanceInput = ""
        slowPermeanceInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MembraneGasSeparationView()
    }
}
