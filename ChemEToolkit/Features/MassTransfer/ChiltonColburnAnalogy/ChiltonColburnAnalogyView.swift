import SwiftUI

struct ChiltonColburnAnalogyView: View {
    @State
    private var frictionFactorInput =
        "0.005"

    @State
    private var reynoldsInput = "100000"

    @State
    private var schmidtInput = "1"

    @State
    private var velocityInput = "2"

    @State
    private var result:
        ChiltonColburnAnalogyResult?

    @State
    private var errorMessage = ""

    private let engine =
        ChiltonColburnAnalogyEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.triangle.branch",
                    title:
                        "Chilton–Colburn Analogy",
                    subtitle:
                        "Estimate mass-transfer performance from turbulent-flow friction data",
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
            "Chilton–Colburn Analogy"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Mass-Transfer j-Factor"
                )
                .font(.headline)

                Text(
                    "jD = Stₘ Sc²ᐟ³ = fF/2"
                )
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.6)
                .multilineTextAlignment(.center)

                Text(
                    "Sh = jD Re Sc¹ᐟ³"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )

                Text(
                    """
                    Uses the Fanning friction factor for fully \
                    developed turbulent conduit flow. Implemented \
                    range: Re ≥ 10000 and 0.6 ≤ Sc ≤ 3000.
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
            Text("Flow and Transport Inputs")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Fanning Friction Factor",
                symbol: "fF",
                unit: "—",
                placeholder:
                    "Example: 0.005",
                text: $frictionFactorInput
            )

            EngineeringInputField(
                title: "Reynolds Number",
                symbol: "Re",
                unit: "—",
                placeholder:
                    "Example: 100000",
                text: $reynoldsInput
            )

            EngineeringInputField(
                title: "Schmidt Number",
                symbol: "Sc",
                unit: "—",
                placeholder: "Example: 1",
                text: $schmidtInput
            )

            EngineeringInputField(
                title: "Average Velocity",
                symbol: "u",
                unit: "m/s",
                placeholder: "Example: 2",
                text: $velocityInput
            )

            CalculatorInfoCard(tint: .orange) {
                Label(
                    "Enter the Fanning friction factor, not the Darcy friction factor.",
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
                    "Calculate Mass-Transfer Analogy",
                systemImage:
                    "arrow.triangle.branch",
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
            ChiltonColburnAnalogyResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Mass-Transfer j-Factor",
                        value:
                            numberFormatter.format(
                                result
                                    .massTransferJFactor
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Mass Stanton Number",
                        value:
                            numberFormatter.format(
                                result
                                    .massTransferStantonNumber
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
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Sherwood Number",
                        value:
                            numberFormatter.format(
                                result
                                    .sherwoodNumber
                            ),
                        unit: "—"
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
                        "Analogy Summary",
                        systemImage:
                            "arrow.triangle.branch"
                    )
                    .font(.headline)

                    Divider()

                    Text(result.modelName)
                        .fontWeight(.semibold)

                    Text(
                        result
                            .frictionFactorConvention
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
        -> ChiltonColburnAnalogyInput {

        ChiltonColburnAnalogyInput(
            fanningFrictionFactor:
                try InputValidator.parseNumber(
                    frictionFactorInput,
                    fieldName:
                        "Fanning friction factor"
                ),
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
            averageVelocity:
                try InputValidator.parseNumber(
                    velocityInput,
                    fieldName:
                        "average velocity"
                )
        )
    }

    private func loadExample() {
        frictionFactorInput = "0.005"
        reynoldsInput = "100000"
        schmidtInput = "1"
        velocityInput = "2"
        clearResult()
    }

    private func resetInputs() {
        frictionFactorInput = ""
        reynoldsInput = ""
        schmidtInput = ""
        velocityInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ChiltonColburnAnalogyView()
    }
}
