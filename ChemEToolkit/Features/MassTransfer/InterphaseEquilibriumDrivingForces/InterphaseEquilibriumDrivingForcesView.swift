import SwiftUI

struct InterphaseEquilibriumDrivingForcesView:
    View {

    @State
    private var equilibriumSlopeInput =
        "1.5"

    @State
    private var gasBulkMoleFractionInput =
        "0.4"

    @State
    private var liquidBulkMoleFractionInput =
        "0.1"

    @State
    private var interfaceLiquidMoleFractionInput =
        "0.2"

    @State
    private var result:
        InterphaseEquilibriumDrivingForcesResult?

    @State
    private var errorMessage = ""

    private let engine =
        InterphaseEquilibriumDrivingForcesEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.left.arrow.right.circle.fill",
                    title:
                        "Interphase Equilibrium & Driving Forces",
                    subtitle:
                        "Evaluate interface equilibrium and gas-side and liquid-side driving forces",
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
            "Interphase Driving Forces"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Linear Interphase Equilibrium"
                )
                .font(.headline)

                Text("y* = mx")
                    .font(
                        .system(
                            size: 24,
                            weight: .semibold
                        )
                    )

                Text(
                    """
                    The interface phases are assumed to be at \
                    equilibrium. Signed driving forces preserve \
                    the predicted absorption or stripping direction.
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
            Text("Equilibrium Relation")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Equilibrium-Line Slope",
                symbol: "m",
                unit: "—",
                placeholder: "Example: 1.5",
                text:
                    $equilibriumSlopeInput
            )

            Divider()

            Text("Bulk and Interface Compositions")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Bulk Gas Mole Fraction",
                symbol: "yG",
                unit: "—",
                placeholder: "Example: 0.4",
                text:
                    $gasBulkMoleFractionInput
            )

            EngineeringInputField(
                title:
                    "Bulk Liquid Mole Fraction",
                symbol: "xL",
                unit: "—",
                placeholder: "Example: 0.1",
                text:
                    $liquidBulkMoleFractionInput
            )

            EngineeringInputField(
                title:
                    "Interface Liquid Mole Fraction",
                symbol: "xi",
                unit: "—",
                placeholder: "Example: 0.2",
                text:
                    $interfaceLiquidMoleFractionInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Driving Forces",
                systemImage:
                    "arrow.left.arrow.right.circle.fill",
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
            InterphaseEquilibriumDrivingForcesResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Interface Gas Mole Fraction",
                        value:
                            numberFormatter.format(
                                result
                                    .interfaceGasMoleFraction
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Equilibrium Gas Composition, y*",
                        value:
                            numberFormatter.format(
                                result
                                    .equilibriumGasMoleFractionForBulkLiquid
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Equilibrium Liquid Composition, x*",
                        value:
                            numberFormatter.format(
                                result
                                    .equilibriumLiquidMoleFractionForBulkGas
                            ),
                        unit: "—"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Gas-Film Driving Force",
                        value:
                            numberFormatter.format(
                                result
                                    .gasFilmDrivingForce
                            ),
                        unit: "Δy"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Liquid-Film Driving Force",
                        value:
                            numberFormatter.format(
                                result
                                    .liquidFilmDrivingForce
                            ),
                        unit: "Δx"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Overall Gas Driving Force",
                        value:
                            numberFormatter.format(
                                result
                                    .overallGasDrivingForce
                            ),
                        unit: "Δy"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Overall Liquid Driving Force",
                        value:
                            numberFormatter.format(
                                result
                                    .overallLiquidDrivingForce
                            ),
                        unit: "Δx"
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
                        "Physical Interpretation",
                        systemImage:
                            "arrow.left.arrow.right.circle.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(result.directionDescription)
                        .fontWeight(.semibold)

                    Text(
                        result
                            .consistencyDescription
                    )
                    .foregroundStyle(.secondary)

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
        -> InterphaseEquilibriumDrivingForcesInput {

        InterphaseEquilibriumDrivingForcesInput(
            equilibriumSlope:
                try InputValidator.parseNumber(
                    equilibriumSlopeInput,
                    fieldName:
                        "equilibrium-line slope"
                ),
            gasBulkMoleFraction:
                try InputValidator.parseNumber(
                    gasBulkMoleFractionInput,
                    fieldName:
                        "bulk gas mole fraction"
                ),
            liquidBulkMoleFraction:
                try InputValidator.parseNumber(
                    liquidBulkMoleFractionInput,
                    fieldName:
                        "bulk liquid mole fraction"
                ),
            interfaceLiquidMoleFraction:
                try InputValidator.parseNumber(
                    interfaceLiquidMoleFractionInput,
                    fieldName:
                        "interface liquid mole fraction"
                )
        )
    }

    private func loadExample() {
        equilibriumSlopeInput = "1.5"
        gasBulkMoleFractionInput = "0.4"
        liquidBulkMoleFractionInput = "0.1"
        interfaceLiquidMoleFractionInput =
            "0.2"
        clearResult()
    }

    private func resetInputs() {
        equilibriumSlopeInput = ""
        gasBulkMoleFractionInput = ""
        liquidBulkMoleFractionInput = ""
        interfaceLiquidMoleFractionInput =
            ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        InterphaseEquilibriumDrivingForcesView()
    }
}
