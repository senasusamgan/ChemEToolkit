import SwiftUI

struct SemibatchReactorView:
    View {

    @State private var initialVolumeInput =
        "1"

    @State private var initialMolesBInput =
        "1"

    @State private var feedConcentrationInput =
        "2"

    @State private var feedFlowInput =
        "0.1"

    @State private var rateConstantInput =
        "1"

    @State private var operationTimeInput =
        "5"

    @State private var result:
        SemibatchReactorResult?

    @State private var errorMessage = ""

    private let engine =
        SemibatchReactorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "drop.degreesign.fill",
                    title:
                        "Semibatch Reactor",
                    subtitle:
                        "Integrate variable-volume A feed reacting with initially charged B",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Variable-Volume Molar Balances")
                            .font(.headline)

                        Text("A + B → P")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "A enters continuously while B is initially charged; no outlet stream leaves during operation."
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
                                "Initial Liquid Volume",
                            symbol: "V₀",
                            unit: "m³",
                            placeholder: "1",
                            text:
                                $initialVolumeInput
                        )

                        EngineeringInputField(
                            title:
                                "Initial Moles B",
                            symbol: "N_B0",
                            unit: "mol",
                            placeholder: "1",
                            text:
                                $initialMolesBInput
                        )

                        EngineeringInputField(
                            title:
                                "Feed Concentration A",
                            symbol: "C_Af",
                            unit: "mol/m³",
                            placeholder: "2",
                            text:
                                $feedConcentrationInput
                        )

                        EngineeringInputField(
                            title:
                                "Feed Volumetric Flow",
                            symbol: "F",
                            unit: "m³/time",
                            placeholder: "0.1",
                            text: $feedFlowInput
                        )

                        EngineeringInputField(
                            title:
                                "Second-Order Rate Constant",
                            symbol: "k",
                            unit:
                                "m³/(mol·time)",
                            placeholder: "1",
                            text:
                                $rateConstantInput
                        )

                        EngineeringInputField(
                            title:
                                "Operation Time",
                            symbol: "t",
                            unit: "time",
                            placeholder: "5",
                            text:
                                $operationTimeInput
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
                                "Integrate Semibatch Reactor",
                            systemImage:
                                "drop.degreesign.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Final Liquid Volume",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalLiquidVolume
                                                ),
                                            unit: "m³"
                                        ),
                                        .init(
                                            label:
                                                "Product Moles",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .productMoles
                                                ),
                                            unit: "mol"
                                        ),
                                        .init(
                                            label:
                                                "Conversion of Fed A",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionOfFedA
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Conversion of Initial B",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .conversionOfInitialB
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Final Concentration A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .finalConcentrationA
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Maximum Reaction Rate",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .maximumReactionRate
                                                ),
                                            unit: "mol/time"
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
        .navigationTitle("Semibatch Reactor")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialLiquidVolume:
                        try InputValidator.parseNumber(
                            initialVolumeInput,
                            fieldName:
                                "initial liquid volume"
                        ),
                    initialMolesB:
                        try InputValidator.parseNumber(
                            initialMolesBInput,
                            fieldName:
                                "initial moles B"
                        ),
                    feedConcentrationA:
                        try InputValidator.parseNumber(
                            feedConcentrationInput,
                            fieldName:
                                "feed concentration A"
                        ),
                    feedVolumetricFlowRate:
                        try InputValidator.parseNumber(
                            feedFlowInput,
                            fieldName:
                                "feed volumetric flow"
                        ),
                    secondOrderRateConstant:
                        try InputValidator.parseNumber(
                            rateConstantInput,
                            fieldName:
                                "second-order rate constant"
                        ),
                    operationTime:
                        try InputValidator.parseNumber(
                            operationTimeInput,
                            fieldName:
                                "operation time"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialVolumeInput = "1"
        initialMolesBInput = "1"
        feedConcentrationInput = "2"
        feedFlowInput = "0.1"
        rateConstantInput = "1"
        operationTimeInput = "5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialVolumeInput = ""
        initialMolesBInput = ""
        feedConcentrationInput = ""
        feedFlowInput = ""
        rateConstantInput = ""
        operationTimeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SemibatchReactorView()
    }
}
