import SwiftUI

struct EconomicReactorSelectionView:
    View {

    @State private var flowInput = "1"
    @State private var rateInput = "0.5"
    @State private var conversionInput = "0.8"
    @State private var pfrCapitalInput = "100000"
    @State private var cstrCapitalInput = "70000"
    @State private var annualizationInput = "0.2"
    @State private var pfrOperatingInput = "10000"
    @State private var cstrOperatingInput = "15000"
    @State private var result:
        EconomicReactorSelectionResult?

    @State private var errorMessage = ""

    private let engine =
        EconomicReactorSelectionEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "dollarsign.circle.fill",
                    title: "Economic Reactor Selection",
                    subtitle: "Compare annualized PFR and CSTR costs for a first-order conversion target",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Required reactor sizes are converted into installed capital and equivalent annual cost.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
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
                        EngineeringInputField(
                            title: "Volumetric Flow Rate",
                            symbol: "Q",
                            unit: "m³/time",
                            placeholder: "1",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "First-Order Rate Constant",
                            symbol: "k",
                            unit: "1/time",
                            placeholder: "0.5",
                            text: $rateInput
                        )

                        EngineeringInputField(
                            title: "Target Conversion",
                            symbol: "X",
                            unit: "—",
                            placeholder: "0.8",
                            text: $conversionInput
                        )

                        EngineeringInputField(
                            title: "PFR Installed Cost per Volume",
                            symbol: "C_PFR",
                            unit: "currency/m³",
                            placeholder: "100000",
                            text: $pfrCapitalInput
                        )

                        EngineeringInputField(
                            title: "CSTR Installed Cost per Volume",
                            symbol: "C_CSTR",
                            unit: "currency/m³",
                            placeholder: "70000",
                            text: $cstrCapitalInput
                        )

                        EngineeringInputField(
                            title: "Annualization Factor",
                            symbol: "f_a",
                            unit: "1/year",
                            placeholder: "0.2",
                            text: $annualizationInput
                        )

                        EngineeringInputField(
                            title: "PFR Annual Operating Cost",
                            symbol: "O_PFR",
                            unit: "currency/year",
                            placeholder: "10000",
                            text: $pfrOperatingInput
                        )

                        EngineeringInputField(
                            title: "CSTR Annual Operating Cost",
                            symbol: "O_CSTR",
                            unit: "currency/year",
                            placeholder: "15000",
                            text: $cstrOperatingInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
                                )
                            }

                            Spacer()

                            Button(
                                role: .destructive,
                                action: resetInputs
                            ) {
                                Label(
                                    "Clear",
                                    systemImage: "trash"
                                )
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "dollarsign.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "PFR Volume",
                                        value: formatter.format(result.requiredPFRVolume),
                                        unit: "m³"
                                    ),
.init(
                                        label: "CSTR Volume",
                                        value: formatter.format(result.requiredCSTRVolume),
                                        unit: "m³"
                                    ),
.init(
                                        label: "PFR Annual Cost",
                                        value: formatter.format(result.pfrEquivalentAnnualCost),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "CSTR Annual Cost",
                                        value: formatter.format(result.cstrEquivalentAnnualCost),
                                        unit: "currency/year"
                                    ),
.init(
                                        label: "Preferred Reactor",
                                        value: result.preferredReactor,
                                        unit: "—"
                                    ),
.init(
                                        label: "Annual Savings",
                                        value: formatter.format(result.annualSavings),
                                        unit: "currency/year"
                                    )
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
                                VStack(
                                    alignment: .leading,
                                    spacing: AppSpacing.small
                                ) {
                                    Text(result.modelName)
                                        .font(.headline)

                                    Divider()

                                    Text(
                                        result
                                            .limitationDescription
                                    )
                                    .foregroundStyle(.secondary)
                                }
                            }
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
        .navigationTitle("Economic Reactor Selection")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    volumetricFlowRate: try InputValidator.parseNumber(flowInput, fieldName: "volumetric flow rate"),
                    firstOrderRateConstant: try InputValidator.parseNumber(rateInput, fieldName: "first-order rate constant"),
                    targetConversion: try InputValidator.parseNumber(conversionInput, fieldName: "target conversion"),
                    pfrInstalledCostPerVolume: try InputValidator.parseNumber(pfrCapitalInput, fieldName: "PFR installed cost per volume"),
                    cstrInstalledCostPerVolume: try InputValidator.parseNumber(cstrCapitalInput, fieldName: "CSTR installed cost per volume"),
                    annualizationFactor: try InputValidator.parseNumber(annualizationInput, fieldName: "annualization factor"),
                    pfrAnnualOperatingCost: try InputValidator.parseNumber(pfrOperatingInput, fieldName: "PFR annual operating cost"),
                    cstrAnnualOperatingCost: try InputValidator.parseNumber(cstrOperatingInput, fieldName: "CSTR annual operating cost")
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        flowInput = "1"
        rateInput = "0.5"
        conversionInput = "0.8"
        pfrCapitalInput = "100000"
        cstrCapitalInput = "70000"
        annualizationInput = "0.2"
        pfrOperatingInput = "10000"
        cstrOperatingInput = "15000"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        flowInput = ""
        rateInput = ""
        conversionInput = ""
        pfrCapitalInput = ""
        cstrCapitalInput = ""
        annualizationInput = ""
        pfrOperatingInput = ""
        cstrOperatingInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EconomicReactorSelectionView()
    }
}
