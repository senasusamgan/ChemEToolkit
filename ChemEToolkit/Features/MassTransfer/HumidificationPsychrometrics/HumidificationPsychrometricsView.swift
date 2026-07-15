import SwiftUI

struct HumidificationPsychrometricsView:
    View {

    @State
    private var dryAirFlowInput =
        "1000"

    @State
    private var temperatureInput = "25"

    @State
    private var pressureInput =
        "101.325"

    @State
    private var inletRelativeHumidityInput =
        "0.3"

    @State
    private var outletRelativeHumidityInput =
        "0.6"

    @State
    private var result:
        HumidificationPsychrometricsResult?

    @State
    private var errorMessage = ""

    private let engine =
        HumidificationPsychrometricsEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.fill",
                    title:
                        "Humidification & Psychrometrics",
                    subtitle:
                        "Calculate humidity ratio, dew point, water transfer and isothermal heat duty",
                    tint: .blue
                )

                formulaCard

                CalculatorCard {
                    calculatorContent
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
        .navigationTitle(
            "Humidification & Psychrometrics"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text("Ideal Moist-Air Relations")
                    .font(.headline)

                Text(
                    "Y = 0.62198 pv / (P − pv)"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)

                Text(
                    "h = 1.005T + Y(2500 + 1.88T)"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.5)

                Text(
                    """
                    Inlet and outlet states use the same dry-bulb \
                    temperature and total pressure. Heat duty is the \
                    ideal isothermal moist-air enthalpy change.
                    """
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
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Air-Stream Conditions")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Dry-Air Mass Flow",
                symbol: "mda",
                unit: "kg dry air/h",
                placeholder: "Example: 1000",
                text: $dryAirFlowInput
            )

            EngineeringInputField(
                title:
                    "Dry-Bulb Temperature",
                symbol: "Tdb",
                unit: "°C",
                placeholder: "Example: 25",
                text: $temperatureInput
            )

            EngineeringInputField(
                title: "Total Pressure",
                symbol: "P",
                unit: "kPa",
                placeholder:
                    "Example: 101.325",
                text: $pressureInput
            )

            Divider()

            Text("Relative-Humidity States")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Inlet Relative Humidity",
                symbol: "φin",
                unit: "fraction",
                placeholder: "Example: 0.3",
                text:
                    $inletRelativeHumidityInput
            )

            EngineeringInputField(
                title:
                    "Outlet Relative Humidity",
                symbol: "φout",
                unit: "fraction",
                placeholder: "Example: 0.6",
                text:
                    $outletRelativeHumidityInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Psychrometric Change",
                systemImage: "drop.fill",
                action: calculate
            )

            if let result {
                resultSection(result)
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private func resultSection(
        _ result:
            HumidificationPsychrometricsResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Saturation Vapor Pressure",
                        value:
                            numberFormatter.format(
                                result
                                    .saturationVaporPressureKPa
                            ),
                        unit: "kPa"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Inlet Humidity Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .inletHumidityRatio
                            ),
                        unit: "kg water/kg dry air"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Outlet Humidity Ratio",
                        value:
                            numberFormatter.format(
                                result
                                    .outletHumidityRatio
                            ),
                        unit: "kg water/kg dry air"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Water-Transfer Magnitude",
                        value:
                            numberFormatter.format(
                                result
                                    .waterTransferMagnitude
                            ),
                        unit: "kg water/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Inlet Dew Point",
                        value:
                            result
                                .inletDewPointCelsius
                                .map {
                                    numberFormatter
                                        .format($0)
                                }
                            ?? "Undefined",
                        unit: "°C"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Outlet Dew Point",
                        value:
                            result
                                .outletDewPointCelsius
                                .map {
                                    numberFormatter
                                        .format($0)
                                }
                            ?? "Undefined",
                        unit: "°C"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Inlet Humid Enthalpy",
                        value:
                            numberFormatter.format(
                                result
                                    .inletHumidEnthalpy
                            ),
                        unit: "kJ/kg dry air"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Outlet Humid Enthalpy",
                        value:
                            numberFormatter.format(
                                result
                                    .outletHumidEnthalpy
                            ),
                        unit: "kJ/kg dry air"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Signed Isothermal Heat Duty",
                        value:
                            numberFormatter.format(
                                result
                                    .signedIsothermalHeatDuty
                            ),
                        unit: "kJ/h"
                    )
                ],
                tint: .blue
            )

            CalculatorInfoCard(tint: .blue) {
                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.small
                ) {
                    Label(
                        "Process Direction",
                        systemImage: "drop.fill"
                    )
                    .font(.headline)

                    Divider()

                    Text(
                        result
                            .directionDescription
                    )
                    .fontWeight(.semibold)

                    Text(result.modelName)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func calculate() {
        clearResult()

        do {
            result = try engine.calculate(
                try makeInput()
            )
        } catch {
            errorMessage =
                MassTransferViewSupport
                    .errorMessage(for: error)
        }
    }

    private func makeInput() throws
        -> HumidificationPsychrometricsInput {

        HumidificationPsychrometricsInput(
            dryAirMassFlowRate:
                try InputValidator.parseNumber(
                    dryAirFlowInput,
                    fieldName:
                        "dry-air mass flow"
                ),
            dryBulbTemperatureCelsius:
                try InputValidator.parseNumber(
                    temperatureInput,
                    fieldName:
                        "dry-bulb temperature"
                ),
            totalPressureKPa:
                try InputValidator.parseNumber(
                    pressureInput,
                    fieldName:
                        "total pressure"
                ),
            inletRelativeHumidity:
                try InputValidator.parseNumber(
                    inletRelativeHumidityInput,
                    fieldName:
                        "inlet relative humidity"
                ),
            outletRelativeHumidity:
                try InputValidator.parseNumber(
                    outletRelativeHumidityInput,
                    fieldName:
                        "outlet relative humidity"
                )
        )
    }

    private func loadExample() {
        dryAirFlowInput = "1000"
        temperatureInput = "25"
        pressureInput = "101.325"
        inletRelativeHumidityInput = "0.3"
        outletRelativeHumidityInput = "0.6"
        clearResult()
    }

    private func resetInputs() {
        dryAirFlowInput = ""
        temperatureInput = ""
        pressureInput = ""
        inletRelativeHumidityInput = ""
        outletRelativeHumidityInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        HumidificationPsychrometricsView()
    }
}
