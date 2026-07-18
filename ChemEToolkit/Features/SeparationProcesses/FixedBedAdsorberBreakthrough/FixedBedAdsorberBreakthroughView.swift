import SwiftUI

        struct FixedBedAdsorberBreakthroughView:
            View {

            @State private var depthInput =
        "1"

    @State private var capacityInput =
        "100"

    @State private var concentrationInput =
        "1"

    @State private var velocityInput =
        "10"

    @State private var kineticInput =
        "0.5"

    @State private var breakthroughInput =
        "0.05"

            @State private var result:
                FixedBedAdsorberBreakthroughResult?

            @State private var errorMessage =
                ""

            private let engine =
                FixedBedAdsorberBreakthroughEngine()

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
                                "rectangle.3.group.bubble.left.fill",
                            title:
                                "Fixed-Bed Adsorber Breakthrough",
                            subtitle:
                                "Estimate breakthrough time with the BDST model",
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
                            "Bed Depth",
                        symbol:
                            "Z",
                        unit:
                            "m",
                        placeholder:
                            "1",
                        text:
                            $depthInput
                    )

                    EngineeringInputField(
                        title:
                            "Bed Capacity Density",
                        symbol:
                            "N0",
                        unit:
                            "model units",
                        placeholder:
                            "100",
                        text:
                            $capacityInput
                    )

                    EngineeringInputField(
                        title:
                            "Inlet Concentration",
                        symbol:
                            "C0",
                        unit:
                            "model units",
                        placeholder:
                            "1",
                        text:
                            $concentrationInput
                    )

                    EngineeringInputField(
                        title:
                            "Superficial Velocity",
                        symbol:
                            "v",
                        unit:
                            "m/h",
                        placeholder:
                            "10",
                        text:
                            $velocityInput
                    )

                    EngineeringInputField(
                        title:
                            "Kinetic Constant",
                        symbol:
                            "k",
                        unit:
                            "model units",
                        placeholder:
                            "0.5",
                        text:
                            $kineticInput
                    )

                    EngineeringInputField(
                        title:
                            "Breakthrough Fraction",
                        symbol:
                            "Cb/C0",
                        unit:
                            "—",
                        placeholder:
                            "0.05",
                        text:
                            $breakthroughInput
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
                                        "rectangle.3.group.bubble.left.fill",
                                    action:
                                        calculate
                                )

                                if let result {
                                    CalculationResultCard(
                                        items: [
                                            .init(
                                label:
                                    "Breakthrough Time",
                                value:
                                    numberFormatter.format(
                                        result.breakthroughTime
                                    ),
                                unit:
                                    "time units"
                            ),
.init(
                                label:
                                    "Capacity Time Term",
                                value:
                                    numberFormatter.format(
                                        result.capacityTimeTerm
                                    ),
                                unit:
                                    "time units"
                            ),
.init(
                                label:
                                    "Kinetic Time Penalty",
                                value:
                                    numberFormatter.format(
                                        result.kineticTimePenalty
                                    ),
                                unit:
                                    "time units"
                            ),
.init(
                                label:
                                    "Breakthrough Concentration",
                                value:
                                    numberFormatter.format(
                                        result.breakthroughConcentration
                                    ),
                                unit:
                                    "concentration units"
                            ),
.init(
                                label:
                                    "Treated Bed-Volumes Index",
                                value:
                                    numberFormatter.format(
                                        result.treatedBedVolumesIndex
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
                    "Fixed-Bed Adsorber Breakthrough"
                )
            }

            private func calculate() {
                result = nil
                errorMessage = ""

                do {
                    result =
                        try engine.calculate(
                            .init(
                                bedDepth:
                            try InputValidator.parseNumber(
                                depthInput,
                                fieldName:
                                    "bed depth"
                            ),
                        bedCapacityDensity:
                            try InputValidator.parseNumber(
                                capacityInput,
                                fieldName:
                                    "bed capacity density"
                            ),
                        inletConcentration:
                            try InputValidator.parseNumber(
                                concentrationInput,
                                fieldName:
                                    "inlet concentration"
                            ),
                        superficialVelocity:
                            try InputValidator.parseNumber(
                                velocityInput,
                                fieldName:
                                    "superficial velocity"
                            ),
                        kineticConstant:
                            try InputValidator.parseNumber(
                                kineticInput,
                                fieldName:
                                    "kinetic constant"
                            ),
                        breakthroughFraction:
                            try InputValidator.parseNumber(
                                breakthroughInput,
                                fieldName:
                                    "breakthrough fraction"
                            )
                            )
                        )
                } catch {
                    errorMessage =
                        error.localizedDescription
                }
            }

            private func resetInputs() {
                depthInput = ""
        capacityInput = ""
        concentrationInput = ""
        velocityInput = ""
        kineticInput = ""
        breakthroughInput = ""

                result = nil
                errorMessage = ""
            }
        }

        #Preview {
            NavigationStack {
                FixedBedAdsorberBreakthroughView()
            }
        }
