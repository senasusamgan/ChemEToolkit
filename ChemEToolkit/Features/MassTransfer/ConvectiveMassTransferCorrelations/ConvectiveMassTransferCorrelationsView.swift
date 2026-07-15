import SwiftUI

struct ConvectiveMassTransferCorrelationsView:
    View {

    @State
    private var correlation:
        ConvectiveMassTransferCorrelation =
            .laminarFlatPlateAverage

    @State
    private var reynoldsInput = "100000"

    @State
    private var schmidtInput = "1"

    @State
    private var diffusivityInput = "0.00002"

    @State
    private var lengthInput = "1"

    @State
    private var result:
        ConvectiveMassTransferCorrelationsResult?

    @State
    private var errorMessage = ""

    private let engine =
        ConvectiveMassTransferCorrelationsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "wind.circle.fill",
                    title:
                        "Convective Mass-Transfer Correlations",
                    subtitle:
                        "Calculate Sherwood number and the average mass-transfer coefficient",
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
            "Convective Correlations"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(correlation.fullName)
                    .font(.headline)

                Text(formulaText)
                    .font(
                        .system(
                            size: 18,
                            weight: .semibold
                        )
                    )
                    .minimumScaleFactor(0.55)
                    .multilineTextAlignment(.center)

                Text("k = ShₗD/L")
                    .font(
                        .system(
                            size: 19,
                            weight: .semibold
                        )
                    )

                Text(
                    "Validity: \(correlation.validityDescription)"
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

    private var formulaText: String {
        switch correlation {
        case .laminarFlatPlateAverage:
            return "Shₗ = 0.664 Reₗ¹ᐟ² Sc¹ᐟ³"

        case .turbulentFlatPlateAverage:
            return """
            Shₗ = (0.037 Reₗ⁰·⁸ − 871) Sc¹ᐟ³
            """
        }
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Correlation")
                .font(.headline)

            Picker(
                "Correlation",
                selection: $correlation
            ) {
                ForEach(
                    ConvectiveMassTransferCorrelation
                        .allCases
                ) { option in
                    Text(option.title)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .onChange(of: correlation) {
                loadCorrelationExample()
            }

            Divider()

            Text("Dimensionless Inputs")
                .font(.headline)

            EngineeringInputField(
                title: "Reynolds Number",
                symbol: "Reₗ",
                unit: "—",
                placeholder:
                    correlation
                    == .laminarFlatPlateAverage
                    ? "Example: 100000"
                    : "Example: 1000000",
                text: $reynoldsInput
            )

            EngineeringInputField(
                title: "Schmidt Number",
                symbol: "Sc",
                unit: "—",
                placeholder: "Example: 1",
                text: $schmidtInput
            )

            Divider()

            Text("Transport Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Mass Diffusivity",
                symbol: "D",
                unit: "m²/s",
                placeholder:
                    "Example: 0.00002",
                text: $diffusivityInput
            )

            EngineeringInputField(
                title:
                    "Characteristic Length",
                symbol: "L",
                unit: "m",
                placeholder: "Example: 1",
                text: $lengthInput
            )

            MassTransferActionButtons(
                loadExample:
                    loadCorrelationExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Convective Transfer",
                systemImage:
                    "wind.circle.fill",
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
            ConvectiveMassTransferCorrelationsResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Sherwood Number",
                        value:
                            numberFormatter.format(
                                result
                                    .sherwoodNumber
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Mass-Transfer Coefficient",
                        value:
                            numberFormatter.format(
                                result
                                    .massTransferCoefficient
                            ),
                        unit: "m/s"
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
                        "Correlation Summary",
                        systemImage:
                            "wind.circle.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(result.correlationName)
                        .fontWeight(.semibold)

                    Text(
                        "Validity: \(result.validityDescription)"
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
        -> ConvectiveMassTransferCorrelationsInput {

        ConvectiveMassTransferCorrelationsInput(
            correlation: correlation,
            reynoldsNumber:
                try InputValidator.parseNumber(
                    reynoldsInput,
                    fieldName:
                        "Reynolds number"
                ),
            schmidtNumber:
                try InputValidator.parseNumber(
                    schmidtInput,
                    fieldName:
                        "Schmidt number"
                ),
            diffusivity:
                try InputValidator.parseNumber(
                    diffusivityInput,
                    fieldName:
                        "mass diffusivity"
                ),
            characteristicLength:
                try InputValidator.parseNumber(
                    lengthInput,
                    fieldName:
                        "characteristic length"
                )
        )
    }

    private func loadCorrelationExample() {
        switch correlation {
        case .laminarFlatPlateAverage:
            reynoldsInput = "100000"

        case .turbulentFlatPlateAverage:
            reynoldsInput = "1000000"
        }

        schmidtInput = "1"
        diffusivityInput = "0.00002"
        lengthInput = "1"
        clearResult()
    }

    private func resetInputs() {
        reynoldsInput = ""
        schmidtInput = ""
        diffusivityInput = ""
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
        ConvectiveMassTransferCorrelationsView()
    }
}
