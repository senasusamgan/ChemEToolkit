import SwiftUI

        struct PsychrometricAirStreamMixingView:
            View {

            @State private var flow1Input =
        "600"

    @State private var temperature1Input =
        "35"

    @State private var humidity1Input =
        "0.010"

    @State private var flow2Input =
        "400"

    @State private var temperature2Input =
        "15"

    @State private var humidity2Input =
        "0.006"

            @State private var result:
                PsychrometricAirStreamMixingResult?

            @State private var errorMessage =
                ""

            private let engine =
                PsychrometricAirStreamMixingEngine()

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
                                "arrow.triangle.merge",
                            title:
                                "Psychrometric Air-Stream Mixing",
                            subtitle:
                                "Mix two humid-air streams on a dry-air basis",
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
                            "Dry-Air Flow 1",
                        symbol:
                            "m1",
                        unit:
                            "kg/h",
                        placeholder:
                            "600",
                        text:
                            $flow1Input
                    )

                    EngineeringInputField(
                        title:
                            "Temperature 1",
                        symbol:
                            "T1",
                        unit:
                            "°C",
                        placeholder:
                            "35",
                        text:
                            $temperature1Input
                    )

                    EngineeringInputField(
                        title:
                            "Humidity Ratio 1",
                        symbol:
                            "w1",
                        unit:
                            "kg/kg dry air",
                        placeholder:
                            "0.010",
                        text:
                            $humidity1Input
                    )

                    EngineeringInputField(
                        title:
                            "Dry-Air Flow 2",
                        symbol:
                            "m2",
                        unit:
                            "kg/h",
                        placeholder:
                            "400",
                        text:
                            $flow2Input
                    )

                    EngineeringInputField(
                        title:
                            "Temperature 2",
                        symbol:
                            "T2",
                        unit:
                            "°C",
                        placeholder:
                            "15",
                        text:
                            $temperature2Input
                    )

                    EngineeringInputField(
                        title:
                            "Humidity Ratio 2",
                        symbol:
                            "w2",
                        unit:
                            "kg/kg dry air",
                        placeholder:
                            "0.006",
                        text:
                            $humidity2Input
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
                                        "arrow.triangle.merge",
                                    action:
                                        calculate
                                )

                                if let result {
                                    CalculationResultCard(
                                        items: [
                                            .init(
                                label:
                                    "Mixed Dry-Air Flow",
                                value:
                                    numberFormatter.format(
                                        result.mixedDryAirFlow
                                    ),
                                unit:
                                    "kg/h"
                            ),
.init(
                                label:
                                    "Mixed Temperature",
                                value:
                                    numberFormatter.format(
                                        result.mixedTemperatureC
                                    ),
                                unit:
                                    "°C"
                            ),
.init(
                                label:
                                    "Mixed Humidity Ratio",
                                value:
                                    numberFormatter.format(
                                        result.mixedHumidityRatio
                                    ),
                                unit:
                                    "kg/kg dry air"
                            ),
.init(
                                label:
                                    "Mixed Enthalpy",
                                value:
                                    numberFormatter.format(
                                        result.mixedEnthalpy
                                    ),
                                unit:
                                    "kJ/kg dry air"
                            ),
.init(
                                label:
                                    "Water-Vapor Flow",
                                value:
                                    numberFormatter.format(
                                        result.mixedWaterVaporFlow
                                    ),
                                unit:
                                    "kg/h"
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
                    "Psychrometric Air-Stream Mixing"
                )
            }

            private func calculate() {
                result = nil
                errorMessage = ""

                do {
                    result =
                        try engine.calculate(
                            .init(
                                dryAirFlow1:
                            try InputValidator.parseNumber(
                                flow1Input,
                                fieldName:
                                    "dry-air flow 1"
                            ),
                        temperature1C:
                            try InputValidator.parseNumber(
                                temperature1Input,
                                fieldName:
                                    "temperature 1"
                            ),
                        humidityRatio1:
                            try InputValidator.parseNumber(
                                humidity1Input,
                                fieldName:
                                    "humidity ratio 1"
                            ),
                        dryAirFlow2:
                            try InputValidator.parseNumber(
                                flow2Input,
                                fieldName:
                                    "dry-air flow 2"
                            ),
                        temperature2C:
                            try InputValidator.parseNumber(
                                temperature2Input,
                                fieldName:
                                    "temperature 2"
                            ),
                        humidityRatio2:
                            try InputValidator.parseNumber(
                                humidity2Input,
                                fieldName:
                                    "humidity ratio 2"
                            )
                            )
                        )
                } catch {
                    errorMessage =
                        error.localizedDescription
                }
            }

            private func resetInputs() {
                flow1Input = ""
        temperature1Input = ""
        humidity1Input = ""
        flow2Input = ""
        temperature2Input = ""
        humidity2Input = ""

                result = nil
                errorMessage = ""
            }
        }

        #Preview {
            NavigationStack {
                PsychrometricAirStreamMixingView()
            }
        }
