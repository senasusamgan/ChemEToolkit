import SwiftUI

        struct PsychrometricAirEnthalpyView:
            View {

            @State private var temperatureInput =
        "30"

    @State private var humidityInput =
        "0.012"

    @State private var dryHeatInput =
        "1.005"

    @State private var vaporHeatInput =
        "1.88"

    @State private var latentHeatInput =
        "2500"

            @State private var result:
                PsychrometricAirEnthalpyResult?

            @State private var errorMessage =
                ""

            private let engine =
                PsychrometricAirEnthalpyEngine()

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
                                "thermometer.and.liquid.waves",
                            title:
                                "Psychrometric Air Enthalpy",
                            subtitle:
                                "Calculate humid-air enthalpy from temperature and humidity ratio",
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
                            "Dry-Bulb Temperature",
                        symbol:
                            "T",
                        unit:
                            "°C",
                        placeholder:
                            "30",
                        text:
                            $temperatureInput
                    )

                    EngineeringInputField(
                        title:
                            "Humidity Ratio",
                        symbol:
                            "w",
                        unit:
                            "kg/kg dry air",
                        placeholder:
                            "0.012",
                        text:
                            $humidityInput
                    )

                    EngineeringInputField(
                        title:
                            "Dry-Air Heat Capacity",
                        symbol:
                            "c_pa",
                        unit:
                            "kJ/kg·K",
                        placeholder:
                            "1.005",
                        text:
                            $dryHeatInput
                    )

                    EngineeringInputField(
                        title:
                            "Vapor Heat Capacity",
                        symbol:
                            "c_pv",
                        unit:
                            "kJ/kg·K",
                        placeholder:
                            "1.88",
                        text:
                            $vaporHeatInput
                    )

                    EngineeringInputField(
                        title:
                            "Reference Latent Heat",
                        symbol:
                            "lambda_0",
                        unit:
                            "kJ/kg",
                        placeholder:
                            "2500",
                        text:
                            $latentHeatInput
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
                                        "thermometer.and.liquid.waves",
                                    action:
                                        calculate
                                )

                                if let result {
                                    CalculationResultCard(
                                        items: [
                                            .init(
                                label:
                                    "Humid-Air Enthalpy",
                                value:
                                    numberFormatter.format(
                                        result.humidAirEnthalpy
                                    ),
                                unit:
                                    "kJ/kg dry air"
                            ),
.init(
                                label:
                                    "Dry-Air Sensible Contribution",
                                value:
                                    numberFormatter.format(
                                        result.dryAirSensibleContribution
                                    ),
                                unit:
                                    "kJ/kg dry air"
                            ),
.init(
                                label:
                                    "Vapor Latent Contribution",
                                value:
                                    numberFormatter.format(
                                        result.vaporLatentContribution
                                    ),
                                unit:
                                    "kJ/kg dry air"
                            ),
.init(
                                label:
                                    "Vapor Sensible Contribution",
                                value:
                                    numberFormatter.format(
                                        result.vaporSensibleContribution
                                    ),
                                unit:
                                    "kJ/kg dry air"
                            ),
.init(
                                label:
                                    "Humid Heat",
                                value:
                                    numberFormatter.format(
                                        result.humidHeat
                                    ),
                                unit:
                                    "kJ/kg dry air·K"
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
                    "Psychrometric Air Enthalpy"
                )
            }

            private func calculate() {
                result = nil
                errorMessage = ""

                do {
                    result =
                        try engine.calculate(
                            .init(
                                dryBulbTemperatureC:
                            try InputValidator.parseNumber(
                                temperatureInput,
                                fieldName:
                                    "dry-bulb temperature"
                            ),
                        humidityRatio:
                            try InputValidator.parseNumber(
                                humidityInput,
                                fieldName:
                                    "humidity ratio"
                            ),
                        dryAirHeatCapacity:
                            try InputValidator.parseNumber(
                                dryHeatInput,
                                fieldName:
                                    "dry-air heat capacity"
                            ),
                        vaporHeatCapacity:
                            try InputValidator.parseNumber(
                                vaporHeatInput,
                                fieldName:
                                    "vapor heat capacity"
                            ),
                        referenceLatentHeat:
                            try InputValidator.parseNumber(
                                latentHeatInput,
                                fieldName:
                                    "reference latent heat"
                            )
                            )
                        )
                } catch {
                    errorMessage =
                        error.localizedDescription
                }
            }

            private func resetInputs() {
                temperatureInput = ""
        humidityInput = ""
        dryHeatInput = ""
        vaporHeatInput = ""
        latentHeatInput = ""

                result = nil
                errorMessage = ""
            }
        }

        #Preview {
            NavigationStack {
                PsychrometricAirEnthalpyView()
            }
        }
