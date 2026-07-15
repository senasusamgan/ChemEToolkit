import SwiftUI

struct MSMPRCrystallizerDesignView:
    View {

    @State
    private var residenceTimeInput = "2"

    @State
    private var growthRateInput =
        "0.0005"

    @State
    private var nucleiDensityInput =
        "100000000"

    @State
    private var crystalDensityInput =
        "2500"

    @State
    private var shapeFactorInput = "0.5"

    @State
    private var slurryFlowInput = "0.1"

    @State
    private var evaluationSizeInput =
        "0.002"

    @State
    private var result:
        MSMPRCrystallizerDesignResult?

    @State
    private var errorMessage = ""

    private let engine =
        MSMPRCrystallizerDesignEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "chart.bar.xaxis",
                    title:
                        "MSMPR Crystallizer Design",
                    subtitle:
                        "Calculate ideal crystal-size distribution, solids loading and production",
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
            "MSMPR Crystallizer Design"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Steady-State Population Balance"
                )
                .font(.headline)

                Text(
                    "n(L) = n0 exp[−L/(Gτ)]"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )

                Text(
                    "μj = n0 j! (Gτ)^(j+1)"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.55)

                Text(
                    """
                    Growth rate G is in m/h and n0 is the nuclei population \
                    density in number/(m³ slurry·m crystal size). \
                    The model is restricted to crystal volume fraction ≤ 0.20.
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
            Text(
                "Residence Time and Population Kinetics"
            )
            .font(.headline)

            EngineeringInputField(
                title: "Residence Time",
                symbol: "τ",
                unit: "h",
                placeholder: "Example: 2",
                text: $residenceTimeInput
            )

            EngineeringInputField(
                title:
                    "Linear Crystal Growth Rate",
                symbol: "G",
                unit: "m/h",
                placeholder:
                    "Example: 0.0005",
                text: $growthRateInput
            )

            EngineeringInputField(
                title:
                    "Nuclei Population Density",
                symbol: "n0",
                unit: "number/m⁴",
                placeholder:
                    "Example: 100000000",
                text: $nucleiDensityInput
            )

            Divider()

            Text("Crystal and Slurry Properties")
                .font(.headline)

            EngineeringInputField(
                title: "Crystal Density",
                symbol: "ρc",
                unit: "kg/m³",
                placeholder: "Example: 2500",
                text: $crystalDensityInput
            )

            EngineeringInputField(
                title:
                    "Volume Shape Factor",
                symbol: "kv",
                unit: "—",
                placeholder: "Example: 0.5",
                text: $shapeFactorInput
            )

            EngineeringInputField(
                title:
                    "Slurry Volumetric Flow",
                symbol: "Q",
                unit: "m³/h",
                placeholder: "Example: 0.1",
                text: $slurryFlowInput
            )

            EngineeringInputField(
                title:
                    "Evaluation Crystal Size",
                symbol: "Leval",
                unit: "m",
                placeholder: "Example: 0.002",
                text: $evaluationSizeInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate MSMPR Distribution",
                systemImage:
                    "chart.bar.xaxis",
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
            MSMPRCrystallizerDesignResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Characteristic Size, Gτ",
                        value:
                            numberFormatter.format(
                                result
                                    .characteristicCrystalSize
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Number-Mean Size",
                        value:
                            numberFormatter.format(
                                result
                                    .numberMeanCrystalSize
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Surface-Weighted Mean, L32",
                        value:
                            numberFormatter.format(
                                result
                                    .surfaceWeightedMeanSize
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Volume-Weighted Mean, L43",
                        value:
                            numberFormatter.format(
                                result
                                    .volumeWeightedMeanSize
                            ),
                        unit: "m"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Crystal Number Concentration",
                        value:
                            numberFormatter.format(
                                result
                                    .totalCrystalNumberConcentration
                            ),
                        unit: "number/m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Solids Volume Fraction",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .solidsVolumeFraction
                            ),
                        unit: "%"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Crystal Mass Concentration",
                        value:
                            numberFormatter.format(
                                result
                                    .crystalMassConcentration
                            ),
                        unit: "kg/m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Crystal Production Rate",
                        value:
                            numberFormatter.format(
                                result
                                    .crystalProductionRate
                            ),
                        unit: "kg/h"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Population Density at Leval",
                        value:
                            numberFormatter.format(
                                result
                                    .populationDensityAtEvaluationSize
                            ),
                        unit: "number/m⁴"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Number Fraction Above Leval",
                        value:
                            numberFormatter.format(
                                100
                                * result
                                    .fractionByNumberAboveEvaluationSize
                            ),
                        unit: "%"
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
                        "MSMPR Assumptions",
                        systemImage:
                            "chart.bar.xaxis"
                    )
                    .font(.headline)

                    Divider()

                    Text(result.modelName)
                        .fontWeight(.semibold)

                    Text(
                        result
                            .limitationDescription
                    )
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
        -> MSMPRCrystallizerDesignInput {

        MSMPRCrystallizerDesignInput(
            residenceTime:
                try InputValidator.parseNumber(
                    residenceTimeInput,
                    fieldName:
                        "residence time"
                ),
            linearCrystalGrowthRate:
                try InputValidator.parseNumber(
                    growthRateInput,
                    fieldName:
                        "linear crystal growth rate"
                ),
            nucleiPopulationDensity:
                try InputValidator.parseNumber(
                    nucleiDensityInput,
                    fieldName:
                        "nuclei population density"
                ),
            crystalDensity:
                try InputValidator.parseNumber(
                    crystalDensityInput,
                    fieldName:
                        "crystal density"
                ),
            crystalVolumeShapeFactor:
                try InputValidator.parseNumber(
                    shapeFactorInput,
                    fieldName:
                        "crystal volume shape factor"
                ),
            slurryVolumetricFlowRate:
                try InputValidator.parseNumber(
                    slurryFlowInput,
                    fieldName:
                        "slurry volumetric flow"
                ),
            evaluationCrystalSize:
                try InputValidator.parseNumber(
                    evaluationSizeInput,
                    fieldName:
                        "evaluation crystal size"
                )
        )
    }

    private func loadExample() {
        residenceTimeInput = "2"
        growthRateInput = "0.0005"
        nucleiDensityInput = "100000000"
        crystalDensityInput = "2500"
        shapeFactorInput = "0.5"
        slurryFlowInput = "0.1"
        evaluationSizeInput = "0.002"
        clearResult()
    }

    private func resetInputs() {
        residenceTimeInput = ""
        growthRateInput = ""
        nucleiDensityInput = ""
        crystalDensityInput = ""
        shapeFactorInput = ""
        slurryFlowInput = ""
        evaluationSizeInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MSMPRCrystallizerDesignView()
    }
}
