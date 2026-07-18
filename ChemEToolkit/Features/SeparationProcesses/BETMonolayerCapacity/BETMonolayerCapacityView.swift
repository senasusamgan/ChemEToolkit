import SwiftUI

        struct BETMonolayerCapacityView:
            View {

            @State private var pressureInput =
        "0.20"

    @State private var capacityInput =
        "5"

    @State private var constantInput =
        "50"

            @State private var result:
                BETMonolayerCapacityResult?

            @State private var errorMessage =
                ""

            private let engine =
                BETMonolayerCapacityEngine()

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
                                "circle.grid.3x3.fill",
                            title:
                                "BET Monolayer Capacity",
                            subtitle:
                                "Calculate multilayer adsorption loading from relative pressure",
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
                            "Relative Pressure",
                        symbol:
                            "P/P0",
                        unit:
                            "—",
                        placeholder:
                            "0.20",
                        text:
                            $pressureInput
                    )

                    EngineeringInputField(
                        title:
                            "Monolayer Capacity",
                        symbol:
                            "q_m",
                        unit:
                            "mol/kg",
                        placeholder:
                            "5",
                        text:
                            $capacityInput
                    )

                    EngineeringInputField(
                        title:
                            "BET Constant",
                        symbol:
                            "C",
                        unit:
                            "—",
                        placeholder:
                            "50",
                        text:
                            $constantInput
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
                                        "circle.grid.3x3.fill",
                                    action:
                                        calculate
                                )

                                if let result {
                                    CalculationResultCard(
                                        items: [
                                            .init(
                                label:
                                    "Equilibrium Loading",
                                value:
                                    numberFormatter.format(
                                        result.equilibriumLoading
                                    ),
                                unit:
                                    "mol/kg"
                            ),
.init(
                                label:
                                    "Monolayer Equivalent",
                                value:
                                    numberFormatter.format(
                                        result.monolayerEquivalent
                                    ),
                                unit:
                                    "q/q_m"
                            ),
.init(
                                label:
                                    "BET Denominator",
                                value:
                                    numberFormatter.format(
                                        result.betDenominator
                                    ),
                                unit:
                                    "—"
                            ),
.init(
                                label:
                                    "BET Transform Ordinate",
                                value:
                                    numberFormatter.format(
                                        result.transformedBETOrdinate
                                    ),
                                unit:
                                    "inverse loading"
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
                    "BET Monolayer Capacity"
                )
            }

            private func calculate() {
                result = nil
                errorMessage = ""

                do {
                    result =
                        try engine.calculate(
                            .init(
                                relativePressure:
                            try InputValidator.parseNumber(
                                pressureInput,
                                fieldName:
                                    "relative pressure"
                            ),
                        monolayerCapacity:
                            try InputValidator.parseNumber(
                                capacityInput,
                                fieldName:
                                    "monolayer capacity"
                            ),
                        betConstant:
                            try InputValidator.parseNumber(
                                constantInput,
                                fieldName:
                                    "bet constant"
                            )
                            )
                        )
                } catch {
                    errorMessage =
                        error.localizedDescription
                }
            }

            private func resetInputs() {
                pressureInput = ""
        capacityInput = ""
        constantInput = ""

                result = nil
                errorMessage = ""
            }
        }

        #Preview {
            NavigationStack {
                BETMonolayerCapacityView()
            }
        }
