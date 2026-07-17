import SwiftUI

struct BinaryDistillationBalanceView:
    View {

    @State private var flowInput = "100"
    @State private var feedFractionInput = "0.50"
    @State private var distillateInput = "0.95"
    @State private var bottomsInput = "0.05"

    @State private var result:
        BinaryDistillationBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        BinaryDistillationBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.up.arrow.down.circle.fill",
                    title: "Binary Distillation Balance",
                    subtitle: "Calculate distillate, bottoms and light-component recovery",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("The light-component composition must decrease from distillate to feed to bottoms.")
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
                            title: "Feed Molar Flow",
                            symbol: "F",
                            unit: "kmol/h",
                            placeholder: "100",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Feed Light Fraction",
                            symbol: "zF",
                            unit: "—",
                            placeholder: "0.50",
                            text: $feedFractionInput
                        )

                        EngineeringInputField(
                            title: "Distillate Light Fraction",
                            symbol: "xD",
                            unit: "—",
                            placeholder: "0.95",
                            text: $distillateInput
                        )

                        EngineeringInputField(
                            title: "Bottoms Light Fraction",
                            symbol: "xB",
                            unit: "—",
                            placeholder: "0.05",
                            text: $bottomsInput
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
                            systemImage: "arrow.up.arrow.down.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Distillate Flow",
                                        value: numberFormatter.format(result.distillateMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Bottoms Flow",
                                        value: numberFormatter.format(result.bottomsMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Light in Distillate",
                                        value: numberFormatter.format(result.lightComponentDistillateFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Light in Bottoms",
                                        value: numberFormatter.format(result.lightComponentBottomsFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Light Recovery to Distillate",
                                        value: numberFormatter.format(100 * result.lightRecoveryToDistillate),
                                        unit: "%"
                                    ),
.init(
                                        label: "Distillate Fraction of Feed",
                                        value: numberFormatter.format(100 * result.distillateFractionOfFeed),
                                        unit: "%"
                                    )
                                ],
                                tint: .purple
                            )

                            CalculatorInfoCard(tint: .purple) {
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
        .navigationTitle("Binary Distillation Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    feedMolarFlow:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName:
                                "feed molar flow"
                        ),
                    feedLightMoleFraction:
                        try InputValidator.parseNumber(
                            feedFractionInput,
                            fieldName:
                                "feed light fraction"
                        ),
                    distillateLightMoleFraction:
                        try InputValidator.parseNumber(
                            distillateInput,
                            fieldName:
                                "distillate light fraction"
                        ),
                    bottomsLightMoleFraction:
                        try InputValidator.parseNumber(
                            bottomsInput,
                            fieldName:
                                "bottoms light fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        flowInput = "100"
        feedFractionInput = "0.50"
        distillateInput = "0.95"
        bottomsInput = "0.05"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        flowInput = ""
        feedFractionInput = ""
        distillateInput = ""
        bottomsInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BinaryDistillationBalanceView()
    }
}
