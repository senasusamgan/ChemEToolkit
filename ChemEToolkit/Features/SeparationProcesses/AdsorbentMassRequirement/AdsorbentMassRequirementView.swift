import SwiftUI

        struct AdsorbentMassRequirementView:
            View {

            @State private var soluteRateInput =
        "2"

    @State private var cycleTimeInput =
        "8"

    @State private var capacityInput =
        "0.20"

    @State private var utilizationInput =
        "0.70"

    @State private var safetyInput =
        "1.20"

            @State private var result:
                AdsorbentMassRequirementResult?

            @State private var errorMessage =
                ""

            private let engine =
                AdsorbentMassRequirementEngine()

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
                                "shippingbox.circle.fill",
                            title:
                                "Adsorbent Mass Requirement",
                            subtitle:
                                "Size adsorbent inventory from working capacity and cycle time",
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
                            "Solute Feed Rate",
                        symbol:
                            "m_dot_s",
                        unit:
                            "kg/h",
                        placeholder:
                            "2",
                        text:
                            $soluteRateInput
                    )

                    EngineeringInputField(
                        title:
                            "Adsorption Cycle Time",
                        symbol:
                            "t_c",
                        unit:
                            "h",
                        placeholder:
                            "8",
                        text:
                            $cycleTimeInput
                    )

                    EngineeringInputField(
                        title:
                            "Equilibrium Capacity",
                        symbol:
                            "q_eq",
                        unit:
                            "kg/kg adsorbent",
                        placeholder:
                            "0.20",
                        text:
                            $capacityInput
                    )

                    EngineeringInputField(
                        title:
                            "Capacity Utilization",
                        symbol:
                            "U",
                        unit:
                            "—",
                        placeholder:
                            "0.70",
                        text:
                            $utilizationInput
                    )

                    EngineeringInputField(
                        title:
                            "Safety Factor",
                        symbol:
                            "SF",
                        unit:
                            "—",
                        placeholder:
                            "1.20",
                        text:
                            $safetyInput
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
                                        "shippingbox.circle.fill",
                                    action:
                                        calculate
                                )

                                if let result {
                                    CalculationResultCard(
                                        items: [
                                            .init(
                                label:
                                    "Design Adsorbent Mass",
                                value:
                                    numberFormatter.format(
                                        result.designAdsorbentMass
                                    ),
                                unit:
                                    "kg"
                            ),
.init(
                                label:
                                    "Theoretical Adsorbent Mass",
                                value:
                                    numberFormatter.format(
                                        result.theoreticalAdsorbentMass
                                    ),
                                unit:
                                    "kg"
                            ),
.init(
                                label:
                                    "Solute per Cycle",
                                value:
                                    numberFormatter.format(
                                        result.solutePerCycle
                                    ),
                                unit:
                                    "kg"
                            ),
.init(
                                label:
                                    "Working Capacity",
                                value:
                                    numberFormatter.format(
                                        result.workingCapacity
                                    ),
                                unit:
                                    "kg/kg adsorbent"
                            ),
.init(
                                label:
                                    "Unused Capacity Fraction",
                                value:
                                    numberFormatter.format(
                                        result.unusedCapacityFraction
                                    ),
                                unit:
                                    "—"
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
                    "Adsorbent Mass Requirement"
                )
            }

            private func calculate() {
                result = nil
                errorMessage = ""

                do {
                    result =
                        try engine.calculate(
                            .init(
                                soluteFeedRate:
                            try InputValidator.parseNumber(
                                soluteRateInput,
                                fieldName:
                                    "solute feed rate"
                            ),
                        cycleTime:
                            try InputValidator.parseNumber(
                                cycleTimeInput,
                                fieldName:
                                    "adsorption cycle time"
                            ),
                        equilibriumCapacity:
                            try InputValidator.parseNumber(
                                capacityInput,
                                fieldName:
                                    "equilibrium capacity"
                            ),
                        utilizationFraction:
                            try InputValidator.parseNumber(
                                utilizationInput,
                                fieldName:
                                    "capacity utilization"
                            ),
                        safetyFactor:
                            try InputValidator.parseNumber(
                                safetyInput,
                                fieldName:
                                    "safety factor"
                            )
                            )
                        )
                } catch {
                    errorMessage =
                        error.localizedDescription
                }
            }

            private func resetInputs() {
                soluteRateInput = ""
        cycleTimeInput = ""
        capacityInput = ""
        utilizationInput = ""
        safetyInput = ""

                result = nil
                errorMessage = ""
            }
        }

        #Preview {
            NavigationStack {
                AdsorbentMassRequirementView()
            }
        }
