import SwiftUI

        struct DryerThermalDutyView:
            View {

            @State private var solidFlowInput =
        "100"

    @State private var inletMoistureInput =
        "0.40"

    @State private var outletMoistureInput =
        "0.10"

    @State private var latentHeatInput =
        "2300"

    @State private var sensibleDutyInput =
        "20000"

    @State private var efficiencyInput =
        "0.75"

            @State private var result:
                DryerThermalDutyResult?

            @State private var errorMessage =
                ""

            private let engine =
                DryerThermalDutyEngine()

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
                                "flame.circle.fill",
                            title:
                                "Dryer Thermal Duty",
                            subtitle:
                                "Estimate latent and sensible heat demand for drying",
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
                            "Dry-Solid Mass Flow",
                        symbol:
                            "m_s",
                        unit:
                            "kg/h",
                        placeholder:
                            "100",
                        text:
                            $solidFlowInput
                    )

                    EngineeringInputField(
                        title:
                            "Inlet Moisture",
                        symbol:
                            "X_i",
                        unit:
                            "kg/kg dry solid",
                        placeholder:
                            "0.40",
                        text:
                            $inletMoistureInput
                    )

                    EngineeringInputField(
                        title:
                            "Outlet Moisture",
                        symbol:
                            "X_o",
                        unit:
                            "kg/kg dry solid",
                        placeholder:
                            "0.10",
                        text:
                            $outletMoistureInput
                    )

                    EngineeringInputField(
                        title:
                            "Latent Heat",
                        symbol:
                            "lambda",
                        unit:
                            "kJ/kg water",
                        placeholder:
                            "2300",
                        text:
                            $latentHeatInput
                    )

                    EngineeringInputField(
                        title:
                            "Sensible Heat Duty",
                        symbol:
                            "Q_s",
                        unit:
                            "kJ/h",
                        placeholder:
                            "20000",
                        text:
                            $sensibleDutyInput
                    )

                    EngineeringInputField(
                        title:
                            "Thermal Efficiency",
                        symbol:
                            "eta",
                        unit:
                            "—",
                        placeholder:
                            "0.75",
                        text:
                            $efficiencyInput
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
                                        "flame.circle.fill",
                                    action:
                                        calculate
                                )

                                if let result {
                                    CalculationResultCard(
                                        items: [
                                            .init(
                                label:
                                    "Required Heat Input",
                                value:
                                    numberFormatter.format(
                                        result.requiredHeatInput
                                    ),
                                unit:
                                    "kJ/h"
                            ),
.init(
                                label:
                                    "Useful Heat Duty",
                                value:
                                    numberFormatter.format(
                                        result.usefulHeatDuty
                                    ),
                                unit:
                                    "kJ/h"
                            ),
.init(
                                label:
                                    "Latent Heat Duty",
                                value:
                                    numberFormatter.format(
                                        result.latentHeatDuty
                                    ),
                                unit:
                                    "kJ/h"
                            ),
.init(
                                label:
                                    "Evaporated Water",
                                value:
                                    numberFormatter.format(
                                        result.evaporatedWaterFlow
                                    ),
                                unit:
                                    "kg/h"
                            ),
.init(
                                label:
                                    "Heat Loss",
                                value:
                                    numberFormatter.format(
                                        result.heatLoss
                                    ),
                                unit:
                                    "kJ/h"
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
                    "Dryer Thermal Duty"
                )
            }

            private func calculate() {
                result = nil
                errorMessage = ""

                do {
                    result =
                        try engine.calculate(
                            .init(
                                drySolidMassFlow:
                            try InputValidator.parseNumber(
                                solidFlowInput,
                                fieldName:
                                    "dry-solid mass flow"
                            ),
                        inletMoistureDryBasis:
                            try InputValidator.parseNumber(
                                inletMoistureInput,
                                fieldName:
                                    "inlet moisture"
                            ),
                        outletMoistureDryBasis:
                            try InputValidator.parseNumber(
                                outletMoistureInput,
                                fieldName:
                                    "outlet moisture"
                            ),
                        latentHeatOfVaporization:
                            try InputValidator.parseNumber(
                                latentHeatInput,
                                fieldName:
                                    "latent heat"
                            ),
                        sensibleHeatDuty:
                            try InputValidator.parseNumber(
                                sensibleDutyInput,
                                fieldName:
                                    "sensible heat duty"
                            ),
                        thermalEfficiency:
                            try InputValidator.parseNumber(
                                efficiencyInput,
                                fieldName:
                                    "thermal efficiency"
                            )
                            )
                        )
                } catch {
                    errorMessage =
                        error.localizedDescription
                }
            }

            private func resetInputs() {
                solidFlowInput = ""
        inletMoistureInput = ""
        outletMoistureInput = ""
        latentHeatInput = ""
        sensibleDutyInput = ""
        efficiencyInput = ""

                result = nil
                errorMessage = ""
            }
        }

        #Preview {
            NavigationStack {
                DryerThermalDutyView()
            }
        }
