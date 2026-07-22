import SwiftUI

struct FiniteVolumeDialysisView:
    View {

    @State
    private var donorVolumeInput = "1"

    @State
    private var receiverVolumeInput = "2"

    @State
    private var membraneAreaInput = "5"

    @State
    private var coefficientInput =
        "0.00001"

    @State
    private var contactTimeInput =
        "3600"

    @State
    private var donorConcentrationInput =
        "10"

    @State
    private var receiverConcentrationInput =
        "0"

    @State
    private var result:
        FiniteVolumeDialysisResult?

    @State
    private var errorMessage = ""

    private let engine =
        FiniteVolumeDialysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "rectangle.split.2x1.fill",
                    title:
                        "Finite-Volume Dialysis",
                    subtitle:
                        "Calculate transient membrane transfer between two well-mixed finite compartments",
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
            "Finite-Volume Dialysis"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Transient Two-Compartment Transfer"
                )
                .font(.headline)

                Text(
                    "ΔC(t) = ΔC0 exp[−KA(1/Vd + 1/Vr)t]"
                )
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.42)
                .multilineTextAlignment(.center)

                Text(
                    "Ceq = (Vd Cd,0 + Vr Cr,0)/(Vd + Vr)"
                )
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.42)
                .multilineTextAlignment(.center)

                Text(
                    """
                    Volumes are in m³, concentrations in mol/m³, area in m², \
                    K in m/s and time in seconds. Both compartments are perfectly \
                    mixed and no reaction, osmotic volume change or fouling is included.
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
            Text("Compartment Volumes")
                .font(.headline)

            EngineeringInputField(
                title: "Donor Volume",
                symbol: "Vd",
                unit: "m³",
                placeholder: "Example: 1",
                text: $donorVolumeInput
            )

            EngineeringInputField(
                title: "Receiver Volume",
                symbol: "Vr",
                unit: "m³",
                placeholder: "Example: 2",
                text: $receiverVolumeInput
            )

            Divider()

            Text("Membrane and Contact Time")
                .font(.headline)

            EngineeringInputField(
                title: "Membrane Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 5",
                text: $membraneAreaInput
            )

            EngineeringInputField(
                title:
                    "Overall Mass-Transfer Coefficient",
                symbol: "K",
                unit: "m/s",
                placeholder:
                    "Example: 0.00001",
                text: $coefficientInput
            )

            EngineeringInputField(
                title: "Contact Time",
                symbol: "t",
                unit: "s",
                placeholder: "Example: 3600",
                text: $contactTimeInput
            )

            Divider()

            Text("Initial Concentrations")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Donor Initial Concentration",
                symbol: "Cd,0",
                unit: "mol/m³",
                placeholder: "Example: 10",
                text:
                    $donorConcentrationInput
            )

            EngineeringInputField(
                title:
                    "Receiver Initial Concentration",
                symbol: "Cr,0",
                unit: "mol/m³",
                placeholder: "Example: 0",
                text:
                    $receiverConcentrationInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Dialysis Transfer",
                systemImage:
                    "rectangle.split.2x1.fill",
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
            FiniteVolumeDialysisResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Equilibrium Concentration",
                        value:
                            numberFormatter.format(
                                result
                                    .equilibriumConcentration
                            ),
                        unit: "mol/m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Donor Final Concentration",
                        value:
                            numberFormatter.format(
                                result
                                    .donorFinalConcentration
                            ),
                        unit: "mol/m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Receiver Final Concentration",
                        value:
                            numberFormatter.format(
                                result
                                    .receiverFinalConcentration
                            ),
                        unit: "mol/m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Transfer Magnitude",
                        value:
                            numberFormatter.format(
                                result.transferMagnitude
                            ),
                        unit: "mol"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Approach to Equilibrium",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .fractionOfEquilibriumApproach
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Initial Signed Flux",
                        value:
                            numberFormatter.format(
                                result
                                    .initialSignedFlux
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Final Signed Flux",
                        value:
                            numberFormatter.format(
                                result.finalSignedFlux
                            ),
                        unit: "mol/(m²·s)"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "System Rate Constant",
                        value:
                            numberFormatter.format(
                                result
                                    .systemRateConstant
                            ),
                        unit: "1/s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Concentration-Difference Half-Time",
                        value:
                            numberFormatter.format(
                                result
                                    .concentrationDifferenceHalfTime
                            ),
                        unit: "s"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Amount-Balance Residual",
                        value:
                            numberFormatter.format(
                                result
                                    .totalAmountBalanceResidual
                            ),
                        unit: "mol"
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
                        "Transfer Direction",
                        systemImage:
                            "rectangle.split.2x1.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result
                            .directionDescription
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
        -> FiniteVolumeDialysisInput {

        FiniteVolumeDialysisInput(
            donorVolume:
                try InputValidator.parseNumber(
                    donorVolumeInput,
                    fieldName:
                        "donor volume"
                ),
            receiverVolume:
                try InputValidator.parseNumber(
                    receiverVolumeInput,
                    fieldName:
                        "receiver volume"
                ),
            membraneArea:
                try InputValidator.parseNumber(
                    membraneAreaInput,
                    fieldName:
                        "membrane area"
                ),
            overallMassTransferCoefficient:
                try InputValidator.parseNumber(
                    coefficientInput,
                    fieldName:
                        "overall mass-transfer coefficient"
                ),
            contactTime:
                try InputValidator.parseNumber(
                    contactTimeInput,
                    fieldName:
                        "contact time"
                ),
            donorInitialConcentration:
                try InputValidator.parseNumber(
                    donorConcentrationInput,
                    fieldName:
                        "donor initial concentration"
                ),
            receiverInitialConcentration:
                try InputValidator.parseNumber(
                    receiverConcentrationInput,
                    fieldName:
                        "receiver initial concentration"
                )
        )
    }

    private func loadExample() {
        donorVolumeInput = "1"
        receiverVolumeInput = "2"
        membraneAreaInput = "5"
        coefficientInput = "0.00001"
        contactTimeInput = "3600"
        donorConcentrationInput = "10"
        receiverConcentrationInput = "0"
        clearResult()
    }

    private func resetInputs() {
        donorVolumeInput = ""
        receiverVolumeInput = ""
        membraneAreaInput = ""
        coefficientInput = ""
        contactTimeInput = ""
        donorConcentrationInput = ""
        receiverConcentrationInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FiniteVolumeDialysisView()
    }
}
