import SwiftUI

struct PhaseChangeEnergyBalanceView:
    View {

    @State private var flowInput = "1.5"
    @State private var latentInput = "2257"
    @State private var fractionInput = "0.80"

    @State private var result:
        PhaseChangeEnergyBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        PhaseChangeEnergyBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "cloud.sun.rain.fill",
                    title: "Phase-Change Energy Balance",
                    subtitle: "Calculate latent-heat duty for partial phase change",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("The entered fraction represents the portion of feed undergoing vaporization, condensation, melting or freezing.")
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
                            title: "Mass Flow Rate",
                            symbol: "ṁ",
                            unit: "kg/s",
                            placeholder: "1.5",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Latent Heat",
                            symbol: "λ",
                            unit: "kJ/kg",
                            placeholder: "2257",
                            text: $latentInput
                        )

                        EngineeringInputField(
                            title: "Phase-Change Fraction",
                            symbol: "f",
                            unit: "—",
                            placeholder: "0.80",
                            text: $fractionInput
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
                            systemImage: "cloud.sun.rain.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Transformed Mass Flow",
                                        value: numberFormatter.format(result.transformedMassFlow),
                                        unit: "kg/s"
                                    ),
.init(
                                        label: "Untransformed Mass Flow",
                                        value: numberFormatter.format(result.untransformedMassFlow),
                                        unit: "kg/s"
                                    ),
.init(
                                        label: "Heat Duty",
                                        value: numberFormatter.format(result.heatDuty),
                                        unit: "kW"
                                    ),
.init(
                                        label: "Specific Duty on Feed Basis",
                                        value: numberFormatter.format(result.specificDutyOnFeedBasis),
                                        unit: "kJ/kg feed"
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
        .navigationTitle("Phase-Change Energy Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    massFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName:
                                "mass flow rate"
                        ),
                    latentHeat:
                        try InputValidator.parseNumber(
                            latentInput,
                            fieldName:
                                "latent heat"
                        ),
                    phaseChangeFraction:
                        try InputValidator.parseNumber(
                            fractionInput,
                            fieldName:
                                "phase-change fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        flowInput = "1.5"
        latentInput = "2257"
        fractionInput = "0.80"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        flowInput = ""
        latentInput = ""
        fractionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PhaseChangeEnergyBalanceView()
    }
}
