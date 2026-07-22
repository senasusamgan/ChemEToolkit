import SwiftUI

struct IonExchangeBedSizingView:
    View {

    @State
    private var flowInput = "2"

    @State
    private var concentrationInput = "5"

    @State
    private var chargeInput = "2"

    @State
    private var removalInput = "0.9"

    @State
    private var serviceTimeInput = "8"

    @State
    private var resinCapacityInput =
        "1.8"

    @State
    private var utilizationInput =
        "0.75"

    @State
    private var result:
        IonExchangeBedSizingResult?

    @State
    private var errorMessage = ""

    private let engine =
        IonExchangeBedSizingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "arrow.left.arrow.right.square.fill",
                    title:
                        "Ion Exchange Bed Sizing",
                    subtitle:
                        "Size resin volume from ionic equivalent load and usable capacity",
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
            "Ion Exchange Bed Sizing"
        )
    }

    private var formulaCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.small) {
                Text(
                    "Equivalent-Capacity Balance"
                )
                .font(.headline)

                Text(
                    "Equivalent load = Q C |z| t"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )

                Text(
                    "Vresin = removed equivalents / usable capacity"
                )
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .minimumScaleFactor(0.48)
                .multilineTextAlignment(.center)

                Text(
                    """
                    Concentration is mol ion per m³ liquid. Resin capacity \
                    is equivalents per liter of wet resin. Utilization \
                    accounts for the fraction of nominal capacity used in service.
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
            Text("Liquid Service")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Liquid Volumetric Flow",
                symbol: "Q",
                unit: "m³/h",
                placeholder: "Example: 2",
                text: $flowInput
            )

            EngineeringInputField(
                title:
                    "Influent Ion Concentration",
                symbol: "Cin",
                unit: "mol/m³",
                placeholder: "Example: 5",
                text: $concentrationInput
            )

            EngineeringInputField(
                title:
                    "Ion Charge Magnitude",
                symbol: "|z|",
                unit: "whole number",
                placeholder: "Example: 2",
                text: $chargeInput
            )

            EngineeringInputField(
                title:
                    "Target Removal Fraction",
                symbol: "R",
                unit: "fraction",
                placeholder: "Example: 0.9",
                text: $removalInput
            )

            EngineeringInputField(
                title: "Service Time",
                symbol: "t",
                unit: "h",
                placeholder: "Example: 8",
                text: $serviceTimeInput
            )

            Divider()

            Text("Resin Capacity")
                .font(.headline)

            EngineeringInputField(
                title:
                    "Nominal Resin Capacity",
                symbol: "qresin",
                unit: "eq/L resin",
                placeholder: "Example: 1.8",
                text: $resinCapacityInput
            )

            EngineeringInputField(
                title:
                    "Capacity Utilization",
                symbol: "η",
                unit: "fraction",
                placeholder: "Example: 0.75",
                text: $utilizationInput
            )

            MassTransferActionButtons(
                loadExample: loadExample,
                clear: resetInputs
            )

            PrimaryActionButton(
                title:
                    "Calculate Resin Requirement",
                systemImage:
                    "arrow.left.arrow.right.square.fill",
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
            IonExchangeBedSizingResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label:
                            "Treated Liquid Volume",
                        value:
                            numberFormatter.format(
                                result
                                    .treatedLiquidVolume
                            ),
                        unit: "m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Total Equivalent Load",
                        value:
                            numberFormatter.format(
                                result
                                    .totalEquivalentLoad
                            ),
                        unit: "eq"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Removed Equivalent Load",
                        value:
                            numberFormatter.format(
                                result
                                    .removedEquivalentLoad
                            ),
                        unit: "eq"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Residual Equivalent Load",
                        value:
                            numberFormatter.format(
                                result
                                    .residualEquivalentLoad
                            ),
                        unit: "eq"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Usable Resin Capacity",
                        value:
                            numberFormatter.format(
                                result
                                    .usableResinCapacity
                            ),
                        unit: "eq/L"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Required Resin Volume",
                        value:
                            numberFormatter.format(
                                result
                                    .requiredResinVolumeLiters
                            ),
                        unit: "L"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Required Resin Volume",
                        value:
                            numberFormatter.format(
                                result
                                    .requiredResinVolumeCubicMeters
                            ),
                        unit: "m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Outlet Ion Concentration",
                        value:
                            numberFormatter.format(
                                result
                                    .outletIonConcentration
                            ),
                        unit: "mol/m³"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Empty-Bed Contact Time",
                        value:
                            numberFormatter.format(
                                result
                                    .emptyBedContactTimeMinutes
                            ),
                        unit: "min"
                    ),
                    CalculationResultDisplayItem(
                        label:
                            "Processed Bed Volumes",
                        value:
                            numberFormatter.format(
                                result
                                    .processedBedVolumes
                            ),
                        unit: "BV"
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
                        "Capacity Model",
                        systemImage:
                            "arrow.left.arrow.right.square.fill"
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
        -> IonExchangeBedSizingInput {

        IonExchangeBedSizingInput(
            liquidVolumetricFlowRate:
                try InputValidator.parseNumber(
                    flowInput,
                    fieldName:
                        "liquid volumetric flow"
                ),
            influentIonConcentration:
                try InputValidator.parseNumber(
                    concentrationInput,
                    fieldName:
                        "influent ion concentration"
                ),
            ionChargeMagnitude:
                try InputValidator.parseNumber(
                    chargeInput,
                    fieldName:
                        "ion charge magnitude"
                ),
            targetRemovalFraction:
                try InputValidator.parseNumber(
                    removalInput,
                    fieldName:
                        "target removal fraction"
                ),
            serviceTime:
                try InputValidator.parseNumber(
                    serviceTimeInput,
                    fieldName:
                        "service time"
                ),
            resinCapacity:
                try InputValidator.parseNumber(
                    resinCapacityInput,
                    fieldName:
                        "resin capacity"
                ),
            capacityUtilizationFraction:
                try InputValidator.parseNumber(
                    utilizationInput,
                    fieldName:
                        "capacity utilization fraction"
                )
        )
    }

    private func loadExample() {
        flowInput = "2"
        concentrationInput = "5"
        chargeInput = "2"
        removalInput = "0.9"
        serviceTimeInput = "8"
        resinCapacityInput = "1.8"
        utilizationInput = "0.75"
        clearResult()
    }

    private func resetInputs() {
        flowInput = ""
        concentrationInput = ""
        chargeInput = ""
        removalInput = ""
        serviceTimeInput = ""
        resinCapacityInput = ""
        utilizationInput = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        IonExchangeBedSizingView()
    }
}
