import SwiftUI

struct BypassMixingBalanceView:
    View {

    @State private var feedInput = "100"
    @State private var feedFractionInput = "0.20"
    @State private var bypassInput = "0.30"
    @State private var processedFractionInput = "0.05"

    @State private var result:
        BypassMixingBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        BypassMixingBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.turn.up.right.diamond.fill",
                    title: "Bypass Mixing Balance",
                    subtitle: "Split a bypass, process the main branch and remix",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("The bypass keeps the feed composition while the processed branch returns with the entered composition.")
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
                            title: "Feed Mass Flow",
                            symbol: "F",
                            unit: "kg/h",
                            placeholder: "100",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Feed Component Fraction",
                            symbol: "w_F",
                            unit: "—",
                            placeholder: "0.20",
                            text: $feedFractionInput
                        )

                        EngineeringInputField(
                            title: "Bypass Fraction",
                            symbol: "b",
                            unit: "—",
                            placeholder: "0.30",
                            text: $bypassInput
                        )

                        EngineeringInputField(
                            title: "Processed Stream Fraction",
                            symbol: "w_P",
                            unit: "—",
                            placeholder: "0.05",
                            text: $processedFractionInput
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
                            systemImage: "arrow.triangle.turn.up.right.diamond.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Bypass Mass Flow",
                                        value: numberFormatter.format(result.bypassMassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Processed Branch Flow",
                                        value: numberFormatter.format(result.processedBranchMassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Bypass Component Flow",
                                        value: numberFormatter.format(result.bypassComponentFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Processed Component Flow",
                                        value: numberFormatter.format(result.processedComponentFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Mixed Outlet Flow",
                                        value: numberFormatter.format(result.mixedOutletMassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Mixed Outlet Fraction",
                                        value: numberFormatter.format(result.mixedOutletComponentMassFraction),
                                        unit: "—"
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
        .navigationTitle("Bypass Mixing Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    feedMassFlow:
                        try InputValidator.parseNumber(
                            feedInput,
                            fieldName:
                                "feed mass flow"
                        ),
                    feedComponentMassFraction:
                        try InputValidator.parseNumber(
                            feedFractionInput,
                            fieldName:
                                "feed component fraction"
                        ),
                    bypassFraction:
                        try InputValidator.parseNumber(
                            bypassInput,
                            fieldName:
                                "bypass fraction"
                        ),
                    processedStreamComponentMassFraction:
                        try InputValidator.parseNumber(
                            processedFractionInput,
                            fieldName:
                                "processed stream fraction"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        feedInput = "100"
        feedFractionInput = "0.20"
        bypassInput = "0.30"
        processedFractionInput = "0.05"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        feedFractionInput = ""
        bypassInput = ""
        processedFractionInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BypassMixingBalanceView()
    }
}
