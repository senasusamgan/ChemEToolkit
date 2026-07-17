import SwiftUI

struct TwoStreamMixerBalanceView:
    View {

    @State private var flow1Input = "100"
    @State private var fraction1Input = "0.2"
    @State private var flow2Input = "50"
    @State private var fraction2Input = "0.8"

    @State private var result:
        TwoStreamMixerBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        TwoStreamMixerBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.merge",
                    title: "Two-Stream Mixer Balance",
                    subtitle: "Mix two streams using total and component balances",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Both streams must use the same mass-flow basis and the same component definition.")
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
                            title: "Stream 1 Mass Flow",
                            symbol: "ṁ₁",
                            unit: "kg/h",
                            placeholder: "100",
                            text: $flow1Input
                        )

                        EngineeringInputField(
                            title: "Stream 1 Component Fraction",
                            symbol: "w₁",
                            unit: "—",
                            placeholder: "0.2",
                            text: $fraction1Input
                        )

                        EngineeringInputField(
                            title: "Stream 2 Mass Flow",
                            symbol: "ṁ₂",
                            unit: "kg/h",
                            placeholder: "50",
                            text: $flow2Input
                        )

                        EngineeringInputField(
                            title: "Stream 2 Component Fraction",
                            symbol: "w₂",
                            unit: "—",
                            placeholder: "0.8",
                            text: $fraction2Input
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
                            systemImage: "arrow.triangle.merge",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Outlet Mass Flow",
                                        value: numberFormatter.format(result.outletMassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Stream 1 Component Flow",
                                        value: numberFormatter.format(result.stream1ComponentFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Stream 2 Component Flow",
                                        value: numberFormatter.format(result.stream2ComponentFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Outlet Component Flow",
                                        value: numberFormatter.format(result.outletComponentFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Outlet Component Fraction",
                                        value: numberFormatter.format(result.outletComponentMassFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Outlet Other-Component Flow",
                                        value: numberFormatter.format(result.outletOtherComponentFlow),
                                        unit: "kg/h"
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
        .navigationTitle("Two-Stream Mixer Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    stream1MassFlow:
                        try InputValidator.parseNumber(
                            flow1Input,
                            fieldName:
                                "stream 1 mass flow"
                        ),
                    stream1ComponentMassFraction:
                        try InputValidator.parseNumber(
                            fraction1Input,
                            fieldName:
                                "stream 1 component fraction"
                        ),
                    stream2MassFlow:
                        try InputValidator.parseNumber(
                            flow2Input,
                            fieldName:
                                "stream 2 mass flow"
                        ),
                    stream2ComponentMassFraction:
                        try InputValidator.parseNumber(
                            fraction2Input,
                            fieldName:
                                "stream 2 component fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        flow1Input = "100"
        fraction1Input = "0.2"
        flow2Input = "50"
        fraction2Input = "0.8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        flow1Input = ""
        fraction1Input = ""
        flow2Input = ""
        fraction2Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        TwoStreamMixerBalanceView()
    }
}
