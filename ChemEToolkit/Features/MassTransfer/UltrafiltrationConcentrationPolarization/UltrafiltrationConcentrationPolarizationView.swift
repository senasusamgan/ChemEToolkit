import SwiftUI

struct UltrafiltrationConcentrationPolarizationView:
    View {

    @State private var feedFlowInput = "5"
    @State private var membraneAreaInput = "20"
    @State private var massTransferCoefficientInput = "0.02"
    @State private var bulkConcentrationInput = "10"
    @State private var gelConcentrationInput = "100"
    @State private var sievingCoefficientInput = "0.02"

    @State private var result:
        UltrafiltrationConcentrationPolarizationResult?

    @State private var errorMessage = ""

    private let engine =
        UltrafiltrationConcentrationPolarizationEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "line.3.horizontal.decrease.circle.fill",
                    title:
                        "Ultrafiltration Concentration Polarization",
                    subtitle:
                        "Calculate gel-polarization limiting flux, recovery and retentate concentration",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Gel-Polarization Model")
                            .font(.headline)

                        Text("Jlim = k ln(Cg/Cb)")
                            .font(.system(size: 20, weight: .semibold))

                        Text("Cp = S Cb")
                            .font(.system(size: 18, weight: .semibold))

                        Text(
                            "The model estimates a limiting flux from the concentration-polarization film and uses a specified observed sieving coefficient."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        Text("Flow and Membrane")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Feed Flow",
                            symbol: "Qf",
                            unit: "m³/h",
                            placeholder: "Example: 5",
                            text: $feedFlowInput
                        )

                        EngineeringInputField(
                            title: "Membrane Area",
                            symbol: "A",
                            unit: "m²",
                            placeholder: "Example: 20",
                            text: $membraneAreaInput
                        )

                        EngineeringInputField(
                            title: "Liquid-Side Mass-Transfer Coefficient",
                            symbol: "k",
                            unit: "m/h",
                            placeholder: "Example: 0.02",
                            text: $massTransferCoefficientInput
                        )

                        Divider()

                        Text("Concentration Polarization")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Bulk Solute Concentration",
                            symbol: "Cb",
                            unit: "kg/m³",
                            placeholder: "Example: 10",
                            text: $bulkConcentrationInput
                        )

                        EngineeringInputField(
                            title: "Gel Concentration",
                            symbol: "Cg",
                            unit: "kg/m³",
                            placeholder: "Example: 100",
                            text: $gelConcentrationInput
                        )

                        EngineeringInputField(
                            title: "Observed Sieving Coefficient",
                            symbol: "S",
                            unit: "—",
                            placeholder: "Example: 0.02",
                            text: $sievingCoefficientInput
                        )

                        MassTransferActionButtons(
                            loadExample: loadExample,
                            clear: resetInputs
                        )

                        PrimaryActionButton(
                            title: "Calculate UF Limiting Flux",
                            systemImage:
                                "line.3.horizontal.decrease.circle.fill",
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
        .navigationTitle("Ultrafiltration")
    }

    private func resultSection(
        _ result:
            UltrafiltrationConcentrationPolarizationResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    .init(
                        label: "Limiting Flux",
                        value: numberFormatter.format(
                            result.limitingFluxLMH
                        ),
                        unit: "LMH"
                    ),
                    .init(
                        label: "Polarization Modulus",
                        value: numberFormatter.format(
                            result.polarizationModulus
                        ),
                        unit: "Cg/Cb"
                    ),
                    .init(
                        label: "Permeate Flow",
                        value: numberFormatter.format(
                            result.permeateFlowRate
                        ),
                        unit: "m³/h"
                    ),
                    .init(
                        label: "Retentate Flow",
                        value: numberFormatter.format(
                            result.retentateFlowRate
                        ),
                        unit: "m³/h"
                    ),
                    .init(
                        label: "Volumetric Recovery",
                        value: numberFormatter.format(
                            100 * result.volumetricRecoveryFraction
                        ),
                        unit: "%"
                    ),
                    .init(
                        label: "Permeate Concentration",
                        value: numberFormatter.format(
                            result.permeateSoluteConcentration
                        ),
                        unit: "kg/m³"
                    ),
                    .init(
                        label: "Retentate Concentration",
                        value: numberFormatter.format(
                            result.retentateSoluteConcentration
                        ),
                        unit: "kg/m³"
                    ),
                    .init(
                        label: "Observed Rejection",
                        value: numberFormatter.format(
                            100 * result.observedRejection
                        ),
                        unit: "%"
                    ),
                    .init(
                        label: "Concentration Factor",
                        value: numberFormatter.format(
                            result.concentrationFactor
                        ),
                        unit: "—"
                    ),
                    .init(
                        label: "Solute Balance Residual",
                        value: numberFormatter.format(
                            result.soluteBalanceResidual
                        ),
                        unit: "kg/h"
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
        -> UltrafiltrationConcentrationPolarizationInput {

        .init(
            feedVolumetricFlowRate:
                try InputValidator.parseNumber(
                    feedFlowInput,
                    fieldName: "feed flow"
                ),
            membraneArea:
                try InputValidator.parseNumber(
                    membraneAreaInput,
                    fieldName: "membrane area"
                ),
            liquidSideMassTransferCoefficient:
                try InputValidator.parseNumber(
                    massTransferCoefficientInput,
                    fieldName: "mass-transfer coefficient"
                ),
            bulkSoluteConcentration:
                try InputValidator.parseNumber(
                    bulkConcentrationInput,
                    fieldName: "bulk concentration"
                ),
            gelConcentration:
                try InputValidator.parseNumber(
                    gelConcentrationInput,
                    fieldName: "gel concentration"
                ),
            observedSievingCoefficient:
                try InputValidator.parseNumber(
                    sievingCoefficientInput,
                    fieldName: "observed sieving coefficient"
                )
        )
    }

    private func loadExample() {
        feedFlowInput = "5"
        membraneAreaInput = "20"
        massTransferCoefficientInput = "0.02"
        bulkConcentrationInput = "10"
        gelConcentrationInput = "100"
        sievingCoefficientInput = "0.02"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedFlowInput = ""
        membraneAreaInput = ""
        massTransferCoefficientInput = ""
        bulkConcentrationInput = ""
        gelConcentrationInput = ""
        sievingCoefficientInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        UltrafiltrationConcentrationPolarizationView()
    }
}
