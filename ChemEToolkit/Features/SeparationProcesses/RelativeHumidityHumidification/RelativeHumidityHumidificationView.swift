import SwiftUI

        struct RelativeHumidityHumidificationView:
            View {

            @State private var flowInput =
        "1000"

    @State private var temperatureInput =
        "25"

    @State private var pressureInput =
        "101.325"

    @State private var inletHumidityInput =
        "30"

    @State private var outletHumidityInput =
        "60"

            @State private var result:
                RelativeHumidityHumidificationResult?

            @State private var errorMessage =
                ""

            private let engine =
                RelativeHumidityHumidificationEngine()

            private let numberFormatter =
                NumberFormatterService.precise

            var body: some View {
                ScrollView {
                    VStack(
                        spacing:
                            AppSpacing.xLarge
                    ) {
                        ModuleHeaderView(
                            symbolName:
                                "humidity.badge.plus",
                            title:
                                "Relative-Humidity Humidification",
                            subtitle:
                                "Calculate water demand for a target relative humidity",
                            tint:
                                .purple
                        )

                        CalculatorCard {
                            VStack(
                                alignment:
                                    .leading,
                                spacing:
                                    AppSpacing.large
                            ) {
                            EngineeringInputField(
                        title:
                            "Dry-Air Mass Flow",
                        symbol:
                            "m_da",
                        unit:
                            "kg/h",
                        placeholder:
                            "1000",
                        text:
                            $flowInput
                    )

                    EngineeringInputField(
                        title:
                            "Dry-Bulb Temperature",
                        symbol:
                            "T",
                        unit:
                            "°C",
                        placeholder:
                            "25",
                        text:
                            $temperatureInput
                    )

                    EngineeringInputField(
                        title:
                            "Total Pressure",
                        symbol:
                            "P",
                        unit:
                            "kPa",
                        placeholder:
                            "101.325",
                        text:
                            $pressureInput
                    )

                    EngineeringInputField(
                        title:
                            "Inlet Relative Humidity",
                        symbol:
                            "RH_in",
                        unit:
                            "%",
                        placeholder:
                            "30",
                        text:
                            $inletHumidityInput
                    )

                    EngineeringInputField(
                        title:
                            "Outlet Relative Humidity",
                        symbol:
                            "RH_out",
                        unit:
                            "%",
                        placeholder:
                            "60",
                        text:
                            $outletHumidityInput
                    )

                                HStack {
                                    Spacer()

                                    Button(
                                        role:
                                            .destructive,
                                        action:
                                            resetInputs
                                    ) {
                                        Label(
                                            "Clear",
                                            systemImage:
                                                "trash"
                                        )
                                    }
                                }
                                .buttonStyle(
                                    .bordered
                                )

                                PrimaryActionButton(
                                    title:
                                        "Calculate",
                                    systemImage:
                                        "humidity.badge.plus",
                                    action:
                                        calculate
                                )

                                if let result {
                                    CalculationResultCard(
                                        items: [
                                            .init(
                                label:
                                    "Required Water Flow",
                                value:
                                    numberFormatter.format(
                                        result.requiredWaterFlow
                                    ),
                                unit:
                                    "kg/h"
                            ),
.init(
                                label:
                                    "Inlet Humidity Ratio",
                                value:
                                    numberFormatter.format(
                                        result.inletHumidityRatio
                                    ),
                                unit:
                                    "kg/kg dry air"
                            ),
.init(
                                label:
                                    "Outlet Humidity Ratio",
                                value:
                                    numberFormatter.format(
                                        result.outletHumidityRatio
                                    ),
                                unit:
                                    "kg/kg dry air"
                            ),
.init(
                                label:
                                    "Humidity-Ratio Increase",
                                value:
                                    numberFormatter.format(
                                        result.humidityRatioIncrease
                                    ),
                                unit:
                                    "kg/kg dry air"
                            ),
.init(
                                label:
                                    "Saturation Pressure",
                                value:
                                    numberFormatter.format(
                                        result.saturationPressureKPa
                                    ),
                                unit:
                                    "kPa"
                            )
                                        ],
                                        tint:
                                            .purple
                                    )

                                    CalculatorInfoCard(
                                        tint:
                                            .purple
                                    ) {
                                        VStack(
                                            alignment:
                                                .leading,
                                            spacing:
                                                AppSpacing.small
                                        ) {
                                            Text(
                                                result.modelName
                                            )
                                            .font(
                                                .headline
                                            )

                                            Divider()

                                            Text(
                                                result.limitationDescription
                                            )
                                            .foregroundStyle(
                                                .secondary
                                            )
                                        }
                                    }
                                }

                                if !errorMessage.isEmpty {
                                    CalculationErrorCard(
                                        message:
                                            errorMessage
                                    )
                                }
                            }
                        }
                    }
                    .frame(
                        maxWidth:
                            .infinity
                    )
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
                    "Relative-Humidity Humidification"
                )
            }

            private func calculate() {
                result = nil
                errorMessage = ""

                do {
                    result =
                        try engine.calculate(
                            .init(
                                dryAirMassFlow:
                            try InputValidator.parseNumber(
                                flowInput,
                                fieldName:
                                    "dry-air mass flow"
                            ),
                        dryBulbTemperatureC:
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
                        inletRelativeHumidityPercent:
                            try InputValidator.parseNumber(
                                inletHumidityInput,
                                fieldName:
                                    "inlet relative humidity"
                            ),
                        outletRelativeHumidityPercent:
                            try InputValidator.parseNumber(
                                outletHumidityInput,
                                fieldName:
                                    "outlet relative humidity"
                            )
                            )
                        )
                } catch {
                    errorMessage =
                        error.localizedDescription
                }
            }

            private func resetInputs() {
                flowInput = ""
        temperatureInput = ""
        pressureInput = ""
        inletHumidityInput = ""
        outletHumidityInput = ""

                result = nil
                errorMessage = ""
            }
        }

        #Preview {
            NavigationStack {
                RelativeHumidityHumidificationView()
            }
        }
