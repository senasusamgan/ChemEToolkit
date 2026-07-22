import SwiftUI

struct BETIsothermView: View {
    @State
    private var relativePressureInput =
        "0.2"

    @State
    private var monolayerCapacityInput =
        "0.01"

    @State
    private var betConstantInput = "50"

    @State
    private var molarMassInput =
        "0.028"

    @State
    private var crossSectionInput =
        "0.000000000000000000162"

    @State
    private var result:
        BETIsothermResult?

    @State
    private var errorMessage = ""

    private let engine =
        BETIsothermEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "square.stack.3d.up.fill",
                    title: "BET Isotherm",
                    subtitle:
                        "Calculate multilayer loading, BET transform and specific surface area",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text(
                            "Brunauer–Emmett–Teller Model"
                        )
                        .font(.headline)

                        Text(
                            "q = qm Cx / [(1 − x)(1 + (C − 1)x)]"
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
                            "x = p/p₀; the commonly used linear fitting region is approximately 0.05–0.35."
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
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        Text("BET Parameters")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Relative Pressure",
                            symbol: "p/p₀",
                            unit: "—",
                            placeholder: "Example: 0.2",
                            text: $relativePressureInput
                        )

                        EngineeringInputField(
                            title:
                                "Monolayer Capacity",
                            symbol: "qm",
                            unit: "mol/kg",
                            placeholder: "Example: 0.01",
                            text:
                                $monolayerCapacityInput
                        )

                        EngineeringInputField(
                            title: "BET Constant",
                            symbol: "C",
                            unit: "—",
                            placeholder: "Example: 50",
                            text: $betConstantInput
                        )

                        Divider()

                        Text(
                            "Adsorbate Surface-Area Data"
                        )
                        .font(.headline)

                        EngineeringInputField(
                            title:
                                "Adsorbate Molar Mass",
                            symbol: "M",
                            unit: "kg/mol",
                            placeholder:
                                "Example: 0.028",
                            text: $molarMassInput
                        )

                        EngineeringInputField(
                            title:
                                "Molecular Cross-Sectional Area",
                            symbol: "σ",
                            unit: "m²/molecule",
                            placeholder:
                                "Example: 1.62e-19",
                            text: $crossSectionInput
                        )

                        MassTransferActionButtons(
                            loadExample: loadExample,
                            clear: resetInputs
                        )

                        PrimaryActionButton(
                            title:
                                "Calculate BET Isotherm",
                            systemImage:
                                "square.stack.3d.up.fill",
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
                AppTheme.Layout
                    .pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout
                    .pageVerticalPadding
            )
        }
        .navigationTitle("BET Isotherm")
    }

    private func resultSection(
        _ result: BETIsothermResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    .init(
                        label:
                            "Equilibrium Loading",
                        value:
                            numberFormatter.format(
                                result
                                    .equilibriumLoading
                            ),
                        unit: "mol/kg"
                    ),
                    .init(
                        label:
                            "Loading / Monolayer Capacity",
                        value:
                            numberFormatter.format(
                                result
                                    .monolayerFraction
                            ),
                        unit: "—"
                    ),
                    .init(
                        label:
                            "Adsorbed Mass",
                        value:
                            numberFormatter.format(
                                result
                                    .adsorbedMassPerAdsorbentMass
                            ),
                        unit: "kg/kg"
                    ),
                    .init(
                        label:
                            "BET Transform Ordinate",
                        value:
                            numberFormatter.format(
                                result
                                    .betTransformOrdinate
                            ),
                        unit: "kg/mol"
                    ),
                    .init(
                        label:
                            "Theoretical BET Intercept",
                        value:
                            numberFormatter.format(
                                result
                                    .theoreticalBETIntercept
                            ),
                        unit: "kg/mol"
                    ),
                    .init(
                        label:
                            "Theoretical BET Slope",
                        value:
                            numberFormatter.format(
                                result
                                    .theoreticalBETSlope
                            ),
                        unit: "kg/mol"
                    ),
                    .init(
                        label:
                            "Monolayer Adsorbed Mass",
                        value:
                            numberFormatter.format(
                                result
                                    .monolayerAdsorbedMass
                            ),
                        unit: "kg/kg"
                    ),
                    .init(
                        label:
                            "Specific Surface Area",
                        value:
                            numberFormatter.format(
                                result
                                    .specificSurfaceArea
                            ),
                        unit: "m²/kg"
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
                            .pressureRegion
                            .title
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result
                            .regionDescription
                    )

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
        -> BETIsothermInput {

        .init(
            relativePressure:
                try InputValidator.parseNumber(
                    relativePressureInput,
                    fieldName:
                        "relative pressure"
                ),
            monolayerCapacity:
                try InputValidator.parseNumber(
                    monolayerCapacityInput,
                    fieldName:
                        "monolayer capacity"
                ),
            betConstant:
                try InputValidator.parseNumber(
                    betConstantInput,
                    fieldName:
                        "BET constant"
                ),
            adsorbateMolarMass:
                try InputValidator.parseNumber(
                    molarMassInput,
                    fieldName:
                        "adsorbate molar mass"
                ),
            molecularCrossSectionalArea:
                try InputValidator.parseNumber(
                    crossSectionInput,
                    fieldName:
                        "molecular cross-sectional area"
                )
        )
    }

    private func loadExample() {
        relativePressureInput = "0.2"
        monolayerCapacityInput = "0.01"
        betConstantInput = "50"
        molarMassInput = "0.028"
        crossSectionInput =
            "0.000000000000000000162"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        relativePressureInput = ""
        monolayerCapacityInput = ""
        betConstantInput = ""
        molarMassInput = ""
        crossSectionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BETIsothermView()
    }
}
