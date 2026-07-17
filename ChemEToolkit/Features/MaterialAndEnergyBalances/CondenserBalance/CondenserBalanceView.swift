import SwiftUI

struct CondenserBalanceView:
    View {

    @State private var feedInput = "1000"
    @State private var condensableInput = "0.80"
    @State private var condensationInput = "0.75"

    @State private var result:
        CondenserBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        CondenserBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "cloud.rain.fill",
                    title: "Condenser Balance",
                    subtitle: "Calculate condensate and vent-gas flows",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("A selected fraction of the condensable feed becomes liquid while all noncondensables remain in the vent.")
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
                            title: "Vapor Feed Mass Flow",
                            symbol: "V_F",
                            unit: "kg/h",
                            placeholder: "1000",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Condensable Mass Fraction",
                            symbol: "w_C",
                            unit: "—",
                            placeholder: "0.80",
                            text: $condensableInput
                        )

                        EngineeringInputField(
                            title: "Condensation Fraction",
                            symbol: "f_cond",
                            unit: "of condensable",
                            placeholder: "0.75",
                            text: $condensationInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage:
                                        "arrow.counterclockwise"
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
                            systemImage: "cloud.rain.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Feed Condensable Flow",
                                        value: numberFormatter.format(result.feedCondensableFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Feed Noncondensable Flow",
                                        value: numberFormatter.format(result.feedNoncondensableFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Condensate Liquid Flow",
                                        value: numberFormatter.format(result.condensateLiquidFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Uncondensed Vapor Flow",
                                        value: numberFormatter.format(result.uncondensedVaporFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Vent Gas Flow",
                                        value: numberFormatter.format(result.ventGasFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Vent Condensable Fraction",
                                        value: numberFormatter.format(result.ventCondensableMassFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Overall Feed Condensed",
                                        value: numberFormatter.format(100 * result.overallCondensationFraction),
                                        unit: "%"
                                    )
                                ],
                                tint: .teal
                            )

                            CalculatorInfoCard(tint: .teal) {
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
        .navigationTitle("Condenser Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    vaporFeedMassFlow:
                        try InputValidator.parseNumber(
                            feedInput,
                            fieldName:
                                "vapor feed mass flow"
                        ),
                    condensableMassFraction:
                        try InputValidator.parseNumber(
                            condensableInput,
                            fieldName:
                                "condensable mass fraction"
                        ),
                    condensableCondensationFraction:
                        try InputValidator.parseNumber(
                            condensationInput,
                            fieldName:
                                "condensation fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedInput = "1000"
        condensableInput = "0.80"
        condensationInput = "0.75"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        condensableInput = ""
        condensationInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CondenserBalanceView()
    }
}
