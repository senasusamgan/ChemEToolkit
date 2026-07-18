import SwiftUI

        struct CombinedDryerTimeView:
            View {

            @State private var massInput =
        "100"

    @State private var areaInput =
        "10"

    @State private var initialInput =
        "0.50"

    @State private var criticalInput =
        "0.20"

    @State private var finalInput =
        "0.08"

    @State private var equilibriumInput =
        "0.05"

    @State private var fluxInput =
        "2"

            @State private var result:
                CombinedDryerTimeResult?

            @State private var errorMessage =
                ""

            private let engine =
                CombinedDryerTimeEngine()

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
                                "timer.circle.fill",
                            title:
                                "Combined Dryer Time",
                            subtitle:
                                "Combine constant-rate and linear falling-rate drying periods",
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
                            "Dry-Solid Mass",
                        symbol:
                            "M_s",
                        unit:
                            "kg",
                        placeholder:
                            "100",
                        text:
                            $massInput
                    )

                    EngineeringInputField(
                        title:
                            "Drying Area",
                        symbol:
                            "A",
                        unit:
                            "m²",
                        placeholder:
                            "10",
                        text:
                            $areaInput
                    )

                    EngineeringInputField(
                        title:
                            "Initial Moisture",
                        symbol:
                            "X_i",
                        unit:
                            "kg/kg dry solid",
                        placeholder:
                            "0.50",
                        text:
                            $initialInput
                    )

                    EngineeringInputField(
                        title:
                            "Critical Moisture",
                        symbol:
                            "X_c",
                        unit:
                            "kg/kg dry solid",
                        placeholder:
                            "0.20",
                        text:
                            $criticalInput
                    )

                    EngineeringInputField(
                        title:
                            "Final Moisture",
                        symbol:
                            "X_f",
                        unit:
                            "kg/kg dry solid",
                        placeholder:
                            "0.08",
                        text:
                            $finalInput
                    )

                    EngineeringInputField(
                        title:
                            "Equilibrium Moisture",
                        symbol:
                            "X_e",
                        unit:
                            "kg/kg dry solid",
                        placeholder:
                            "0.05",
                        text:
                            $equilibriumInput
                    )

                    EngineeringInputField(
                        title:
                            "Constant Drying Flux",
                        symbol:
                            "N_c",
                        unit:
                            "kg/m²·h",
                        placeholder:
                            "2",
                        text:
                            $fluxInput
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
                                        "timer.circle.fill",
                                    action:
                                        calculate
                                )

                                if let result {
                                    CalculationResultCard(
                                        items: [
                                            .init(
                                label:
                                    "Total Drying Time",
                                value:
                                    numberFormatter.format(
                                        result.totalDryingTime
                                    ),
                                unit:
                                    "h"
                            ),
.init(
                                label:
                                    "Constant-Rate Time",
                                value:
                                    numberFormatter.format(
                                        result.constantRateTime
                                    ),
                                unit:
                                    "h"
                            ),
.init(
                                label:
                                    "Falling-Rate Time",
                                value:
                                    numberFormatter.format(
                                        result.fallingRateTime
                                    ),
                                unit:
                                    "h"
                            ),
.init(
                                label:
                                    "Total Moisture Removed",
                                value:
                                    numberFormatter.format(
                                        result.totalMoistureRemoved
                                    ),
                                unit:
                                    "kg water"
                            ),
.init(
                                label:
                                    "Constant-Rate Moisture",
                                value:
                                    numberFormatter.format(
                                        result.constantRateMoistureRemoved
                                    ),
                                unit:
                                    "kg water"
                            ),
.init(
                                label:
                                    "Falling-Rate Moisture",
                                value:
                                    numberFormatter.format(
                                        result.fallingRateMoistureRemoved
                                    ),
                                unit:
                                    "kg water"
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
                    "Combined Dryer Time"
                )
            }

            private func calculate() {
                result = nil
                errorMessage = ""

                do {
                    result =
                        try engine.calculate(
                            .init(
                                drySolidMass:
                            try InputValidator.parseNumber(
                                massInput,
                                fieldName:
                                    "dry-solid mass"
                            ),
                        dryingArea:
                            try InputValidator.parseNumber(
                                areaInput,
                                fieldName:
                                    "drying area"
                            ),
                        initialMoistureDryBasis:
                            try InputValidator.parseNumber(
                                initialInput,
                                fieldName:
                                    "initial moisture"
                            ),
                        criticalMoistureDryBasis:
                            try InputValidator.parseNumber(
                                criticalInput,
                                fieldName:
                                    "critical moisture"
                            ),
                        finalMoistureDryBasis:
                            try InputValidator.parseNumber(
                                finalInput,
                                fieldName:
                                    "final moisture"
                            ),
                        equilibriumMoistureDryBasis:
                            try InputValidator.parseNumber(
                                equilibriumInput,
                                fieldName:
                                    "equilibrium moisture"
                            ),
                        constantDryingFlux:
                            try InputValidator.parseNumber(
                                fluxInput,
                                fieldName:
                                    "constant drying flux"
                            )
                            )
                        )
                } catch {
                    errorMessage =
                        error.localizedDescription
                }
            }

            private func resetInputs() {
                massInput = ""
        areaInput = ""
        initialInput = ""
        criticalInput = ""
        finalInput = ""
        equilibriumInput = ""
        fluxInput = ""

                result = nil
                errorMessage = ""
            }
        }

        #Preview {
            NavigationStack {
                CombinedDryerTimeView()
            }
        }
