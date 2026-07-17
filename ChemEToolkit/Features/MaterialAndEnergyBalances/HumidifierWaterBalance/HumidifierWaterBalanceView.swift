import SwiftUI

struct HumidifierWaterBalanceView:
    View {

    @State private var dryGasInput = "1000"
    @State private var inletHumidityInput = "0.01"
    @State private var outletHumidityInput = "0.03"

    @State private var result:
        HumidifierWaterBalanceResult?

    @State private var errorMessage = ""

    private let engine =
        HumidifierWaterBalanceEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "humidity.fill",
                    title: "Humidifier Water Balance",
                    subtitle: "Calculate water addition on a dry-gas basis",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Humidity ratio is entered as mass of water vapor per mass of dry gas.")
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
                            title: "Dry Gas Mass Flow",
                            symbol: "G_d",
                            unit: "kg dry gas/h",
                            placeholder: "1000",
                            text: $dryGasInput
                        )

                        EngineeringInputField(
                            title: "Inlet Humidity Ratio",
                            symbol: "ω₁",
                            unit: "kg water/kg dry gas",
                            placeholder: "0.01",
                            text: $inletHumidityInput
                        )

                        EngineeringInputField(
                            title: "Outlet Humidity Ratio",
                            symbol: "ω₂",
                            unit: "kg water/kg dry gas",
                            placeholder: "0.03",
                            text: $outletHumidityInput
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
                            systemImage: "humidity.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Inlet Water-Vapor Flow",
                                        value: numberFormatter.format(result.inletWaterVaporFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Outlet Water-Vapor Flow",
                                        value: numberFormatter.format(result.outletWaterVaporFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Water Added",
                                        value: numberFormatter.format(result.waterAddedFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Inlet Humid-Gas Flow",
                                        value: numberFormatter.format(result.inletHumidGasFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Outlet Humid-Gas Flow",
                                        value: numberFormatter.format(result.outletHumidGasFlow),
                                        unit: "kg/h"
                                    ),
.init(
                                        label: "Outlet Water Mass Fraction",
                                        value: numberFormatter.format(result.outletWaterMassFraction),
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
        .navigationTitle("Humidifier Water Balance")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    dryGasMassFlow:
                        try InputValidator.parseNumber(
                            dryGasInput,
                            fieldName:
                                "dry gas mass flow"
                        ),
                    inletHumidityRatio:
                        try InputValidator.parseNumber(
                            inletHumidityInput,
                            fieldName:
                                "inlet humidity ratio"
                        ),
                    outletHumidityRatio:
                        try InputValidator.parseNumber(
                            outletHumidityInput,
                            fieldName:
                                "outlet humidity ratio"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        dryGasInput = "1000"
        inletHumidityInput = "0.01"
        outletHumidityInput = "0.03"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        dryGasInput = ""
        inletHumidityInput = ""
        outletHumidityInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        HumidifierWaterBalanceView()
    }
}
