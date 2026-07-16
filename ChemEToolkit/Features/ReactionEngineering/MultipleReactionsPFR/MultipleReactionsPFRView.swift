import SwiftUI

struct MultipleReactionsPFRView:
    View {

    @State private var concentrationInput =
        "1"

    @State private var flowInput =
        "0.01"

    @State private var firstRateInput =
        "0.5"

    @State private var secondRateInput =
        "0.2"

    @State private var conversionInput =
        "0.8"

    @State private var result:
        MultipleReactionsPFRResult?

    @State private var errorMessage = ""

    private let engine =
        MultipleReactionsPFREngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.right.to.line.compact",
                    title:
                        "Multiple Reactions in a PFR",
                    subtitle:
                        "Size a PFR for consecutive first-order reactions A → B → C",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Desired Intermediate Product")
                            .font(.headline)

                        Text("A → B → C")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "The module reports outlet B yield and the residence time at which B reaches its maximum."
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
                        EngineeringInputField(
                            title:
                                "Inlet Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "1",
                            text:
                                $concentrationInput
                        )

                        EngineeringInputField(
                            title:
                                "Volumetric Flow Rate",
                            symbol: "Q",
                            unit: "m³/time",
                            placeholder: "0.01",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title:
                                "Rate Constant A → B",
                            symbol: "k₁",
                            unit: "1/time",
                            placeholder: "0.5",
                            text: $firstRateInput
                        )

                        EngineeringInputField(
                            title:
                                "Rate Constant B → C",
                            symbol: "k₂",
                            unit: "1/time",
                            placeholder: "0.2",
                            text: $secondRateInput
                        )

                        EngineeringInputField(
                            title:
                                "Target Conversion of A",
                            symbol: "X_A",
                            unit: "—",
                            placeholder: "0.8",
                            text: $conversionInput
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
                            title:
                                "Size Multiple-Reaction PFR",
                            systemImage:
                                "arrow.right.to.line.compact",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Required Reactor Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .requiredReactorVolume
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "Required Space Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .requiredSpaceTime
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Outlet Concentration B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .outletConcentrationB
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Yield of B",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .yieldOfB
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Reacted A Ending as B",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .fractionOfReactedAEndingAsB
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "B/C Selectivity",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .selectivityBToC
                                                ),
                                            unit: "—"
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
        .navigationTitle("Multiple Reactions PFR")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    inletConcentrationA:
                        try InputValidator.parseNumber(
                            concentrationInput,
                            fieldName:
                                "inlet concentration A"
                        ),
                    volumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName:
                                "volumetric flow rate"
                        ),
                    firstRateConstant:
                        try InputValidator.parseNumber(
                            firstRateInput,
                            fieldName:
                                "first rate constant"
                        ),
                    secondRateConstant:
                        try InputValidator.parseNumber(
                            secondRateInput,
                            fieldName:
                                "second rate constant"
                        ),
                    targetConversionA:
                        try InputValidator.parseNumber(
                            conversionInput,
                            fieldName:
                                "target conversion of A"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "1"
        flowInput = "0.01"
        firstRateInput = "0.5"
        secondRateInput = "0.2"
        conversionInput = "0.8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        flowInput = ""
        firstRateInput = ""
        secondRateInput = ""
        conversionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MultipleReactionsPFRView()
    }
}
