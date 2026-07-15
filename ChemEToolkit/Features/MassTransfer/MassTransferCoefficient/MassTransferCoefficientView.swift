import SwiftUI

struct MassTransferCoefficientView: View {
    @State
    private var coefficientInput = "0.01"

    @State
    private var bulkConcentrationInput = "2"

    @State
    private var interfaceConcentrationInput =
        "0.5"

    @State
    private var areaInput = "1"

    @State
    private var result:
        MassTransferCoefficientResult?

    @State
    private var errorMessage = ""

    private let engine =
        MassTransferCoefficientEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "gauge.with.dots.needle.50percent",
                    title:
                        "Mass-Transfer Coefficient",
                    subtitle:
                        "Calculate flux and transfer rate from a concentration driving force",
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
            "Mass-Transfer Coefficient"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Film Mass-Transfer Relation"
                )
                .font(.headline)

                Text("Nₐ = k(cₐ,ᵦ − cₐ,ᵢ)")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )

                Text("ṅₐ = NₐA")
                    .font(
                        .system(
                            size: 19,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    Positive flux is defined from the bulk phase \
                    toward the interface. A negative result indicates \
                    transport in the opposite direction.
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
            Text("Transfer Inputs")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Mass-Transfer Coefficient",
                symbol: "k",
                unit: "m/s",
                placeholder: "Example: 0.01",
                text: $coefficientInput
            )

            EngineeringInputField(
                title: "Bulk Concentration",
                symbol: "cₐ,ᵦ",
                unit: "mol/m³",
                placeholder: "Example: 2",
                text:
                    $bulkConcentrationInput
            )

            EngineeringInputField(
                title:
                    "Interface Concentration",
                symbol: "cₐ,ᵢ",
                unit: "mol/m³",
                placeholder: "Example: 0.5",
                text:
                    $interfaceConcentrationInput
            )

            EngineeringInputField(
                title: "Transfer Area",
                symbol: "A",
                unit: "m²",
                placeholder: "Example: 1",
                text: $areaInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Mass Transfer",
                systemImage:
                    "gauge.with.dots.needle.50percent",
                action: calculate
            )

            if let result {
                CalculationResultCard(
                    items: [
                        CalculationResultDisplayItem(
                            label: "Driving Force",
                            value:
                                numberFormatter
                                    .format(
                                        result
                                            .drivingForce
                                    ),
                            unit: "mol/m³"
                        ),
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
        -> MassTransferCoefficientInput {

        MassTransferCoefficientInput(
            massTransferCoefficient:
                try InputValidator.parseNumber(
                    coefficientInput,
                    fieldName:
                        "mass-transfer coefficient"
                ),
            bulkConcentration:
                try InputValidator.parseNumber(
                    bulkConcentrationInput,
                    fieldName:
                        "bulk concentration"
                ),
            interfaceConcentration:
                try InputValidator.parseNumber(
                    interfaceConcentrationInput,
                    fieldName:
                        "interface concentration"
                ),
            area:
                try InputValidator.parseNumber(
                    areaInput,
                    fieldName:
                        "transfer area"
                )
        )
    }

    private func loadExample() {
        coefficientInput = "0.01"
        bulkConcentrationInput = "2"
        interfaceConcentrationInput = "0.5"
        areaInput = "1"
        clearResult()
    }

    private func resetInputs() {
        coefficientInput = ""
        bulkConcentrationInput = ""
        interfaceConcentrationInput = ""
        areaInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MassTransferCoefficientView()
    }
}
