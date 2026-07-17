import SwiftUI

struct FilterCakeBalanceView:
    View {

    @State private var feedInput = "1000"
    @State private var solidFractionInput = "0.20"
    @State private var cakeLiquidInput = "0.30"

    @State private var result:
        FilterCakeBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        FilterCakeBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "line.3.horizontal.decrease.circle",
                    title: "Filter Cake Balance",
                    subtitle: "Calculate wet cake and filtrate production",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("All dry solids are retained in the cake while liquid divides between cake moisture and filtrate.")
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
                            title: "Slurry Feed Mass Flow",
                            symbol: "F",
                            unit: "kg/h",
                            placeholder: "1000",
                            text: $feedInput
                        )

                        EngineeringInputField(
                            title: "Feed Dry-Solid Fraction",
                            symbol: "w_S",
                            unit: "—",
                            placeholder: "0.20",
                            text: $solidFractionInput
                        )

                        EngineeringInputField(
                            title: "Cake Liquid Fraction",
                            symbol: "w_L,cake",
                            unit: "wet basis",
                            placeholder: "0.30",
                            text: $cakeLiquidInput
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
                            systemImage: "line.3.horizontal.decrease.circle",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Dry Solid Flow",
                                        value: numberFormatter.format(result.drySolidFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Feed Liquid Flow",
                                        value: numberFormatter.format(result.feedLiquidFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Wet Cake Flow",
                                        value: numberFormatter.format(result.wetCakeMassFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Cake Liquid Flow",
                                        value: numberFormatter.format(result.cakeLiquidFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Filtrate Liquid Flow",
                                        value: numberFormatter.format(result.filtrateLiquidFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Liquid Recovery to Filtrate",
                                        value: numberFormatter.format(100 * result.liquidRecoveryToFiltrate),
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
        .navigationTitle("Filter Cake Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    slurryFeedMassFlow:
                        try InputValidator.parseNumber(
                            feedInput,
                            fieldName:
                                "slurry feed mass flow"
                        ),
                    feedDrySolidMassFraction:
                        try InputValidator.parseNumber(
                            solidFractionInput,
                            fieldName:
                                "feed dry-solid fraction"
                        ),
                    cakeLiquidMassFraction:
                        try InputValidator.parseNumber(
                            cakeLiquidInput,
                            fieldName:
                                "cake liquid fraction"
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
        solidFractionInput = "0.20"
        cakeLiquidInput = "0.30"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        feedInput = ""
        solidFractionInput = ""
        cakeLiquidInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        FilterCakeBalanceView()
    }
}
