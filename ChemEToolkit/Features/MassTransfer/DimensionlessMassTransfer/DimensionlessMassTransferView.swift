import SwiftUI

struct DimensionlessMassTransferView: View {
    @State
    private var densityInput = "1.2"

    @State
    private var viscosityInput = "0.000018"

    @State
    private var diffusivityInput = "0.00002"

    @State
    private var thermalDiffusivityInput =
        "0.000022"

    @State
    private var coefficientInput = "0.01"

    @State
    private var lengthInput = "0.1"

    @State
    private var result:
        DimensionlessMassTransferResult?

    @State
    private var errorMessage = ""

    private let engine =
        DimensionlessMassTransferEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "number",
                    title:
                        "Mass-Transfer Numbers",
                    subtitle:
                        "Calculate Schmidt, Lewis and Sherwood numbers",
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
            "Mass-Transfer Numbers"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Dimensionless Transport Groups"
                )
                .font(.headline)

                Text("Sc = μ/(ρD)")
                    .font(
                        .system(
                            size: 21,
                            weight: .semibold
                        )
                    )

                Text("Le = α/D    •    Sh = kL/D")
                    .font(
                        .system(
                            size: 19,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    Schmidt compares momentum and mass diffusivity, \
                    Lewis compares thermal and mass diffusivity, and \
                    Sherwood represents convective mass transfer.
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
            Text("Fluid Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Density",
                symbol: "ρ",
                unit: "kg/m³",
                placeholder: "Example: 1.2",
                text: $densityInput
            )

            EngineeringInputField(
                title: "Dynamic Viscosity",
                symbol: "μ",
                unit: "Pa·s",
                placeholder:
                    "Example: 0.000018",
                text: $viscosityInput
            )

            EngineeringInputField(
                title: "Mass Diffusivity",
                symbol: "D",
                unit: "m²/s",
                placeholder:
                    "Example: 0.00002",
                text: $diffusivityInput
            )

            EngineeringInputField(
                title: "Thermal Diffusivity",
                symbol: "α",
                unit: "m²/s",
                placeholder:
                    "Example: 0.000022",
                text:
                    $thermalDiffusivityInput
            )

            Divider()

            Text("Convective Transfer")
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
                title: "Characteristic Length",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 0.1",
                text: $lengthInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Dimensionless Numbers",
                systemImage: "number",
                action: calculate
            )

            if let result {
                CalculationResultCard(
                    items: [
                        CalculationResultDisplayItem(
                            label: "Schmidt Number",
                            value:
                                numberFormatter
                                    .format(
                                        result
                                            .schmidtNumber
                                    ),
                            unit: "—"
                        ),
                        CalculationResultDisplayItem(
                            label: "Lewis Number",
                            value:
                                numberFormatter
                                    .format(
                                        result
                                            .lewisNumber
                                    ),
                            unit: "—"
                        ),
                        CalculationResultDisplayItem(
                            label: "Sherwood Number",
                            value:
                                numberFormatter
                                    .format(
                                        result
                                            .sherwoodNumber
                                    ),
                            unit: "—"
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
        -> DimensionlessMassTransferInput {

        DimensionlessMassTransferInput(
            density:
                try InputValidator.parseNumber(
                    densityInput,
                    fieldName: "density"
                ),
            dynamicViscosity:
                try InputValidator.parseNumber(
                    viscosityInput,
                    fieldName:
                        "dynamic viscosity"
                ),
            diffusivity:
                try InputValidator.parseNumber(
                    diffusivityInput,
                    fieldName:
                        "mass diffusivity"
                ),
            thermalDiffusivity:
                try InputValidator.parseNumber(
                    thermalDiffusivityInput,
                    fieldName:
                        "thermal diffusivity"
                ),
            massTransferCoefficient:
                try InputValidator.parseNumber(
                    coefficientInput,
                    fieldName:
                        "mass-transfer coefficient"
                ),
            characteristicLength:
                try InputValidator.parseNumber(
                    lengthInput,
                    fieldName:
                        "characteristic length"
                )
        )
    }

    private func loadExample() {
        densityInput = "1.2"
        viscosityInput = "0.000018"
        diffusivityInput = "0.00002"
        thermalDiffusivityInput =
            "0.000022"
        coefficientInput = "0.01"
        lengthInput = "0.1"
        clearResult()
    }

    private func resetInputs() {
        densityInput = ""
        viscosityInput = ""
        diffusivityInput = ""
        thermalDiffusivityInput = ""
        coefficientInput = ""
        lengthInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        DimensionlessMassTransferView()
    }
}
