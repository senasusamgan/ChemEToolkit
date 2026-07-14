import SwiftUI
import Charts

struct ReactorComparisonView: View {
    @State
    private var conversionFormat:
        ComparisonConversionFormat = .percentage

    @State private var rateConstantInput = ""
    @State private var conversionInput = ""
    @State private var flowRateInput = ""

    @State
    private var comparisonResult:
        ReactorComparisonResult?

    @State private var errorMessage = ""

    private let engine =
        ReactorComparisonEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.bar.xaxis",
                    title: "CSTR–PFR Comparison",
                    subtitle:
                        "Compare reactor volumes at the same conversion",
                    tint: .blue
                )

                equationCard

                CalculatorCard {
                    calculatorContent
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            .padding(
                .horizontal,
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Reactor Comparison")
        .onChange(of: conversionFormat) { _, _ in
            conversionInput = ""
            clearResults()
        }
    }

    private var calculatorContent: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.large
        ) {
            Text("Conversion Input Format")
                .font(.headline)

            Picker(
                "Conversion Input Format",
                selection: $conversionFormat
            ) {
                ForEach(
                    ComparisonConversionFormat
                        .allCases
                ) { format in
                    Text(format.title)
                        .tag(format)
                }
            }
            .pickerStyle(.segmented)

            Divider()

            CalculatorInputField(
                title: "Rate Constant",
                symbol: "k",
                unit: "1/min",
                placeholder:
                    "Enter rate constant",
                text: $rateConstantInput
            )

            CalculatorInputField(
                title: "Conversion",
                symbol: "X",
                unit: conversionFormat.unit,
                placeholder:
                    conversionFormat.placeholder,
                text: $conversionInput
            )

            CalculatorInputField(
                title: "Volumetric Flow Rate",
                symbol: "v₀",
                unit: "L/min",
                placeholder:
                    "Enter inlet volumetric flow rate",
                text: $flowRateInput
            )

            PrimaryActionButton(
                title: "Compare Reactors",
                systemImage: "chart.bar.fill",
                action: calculateComparison
            )

            if let comparisonResult {
                comparisonResults(
                    comparisonResult
                )
            }

            if !errorMessage.isEmpty {
                CalculationErrorCard(
                    message: errorMessage
                )
            }
        }
    }

    private var equationCard: some View {
        CalculatorInfoCard(tint: .blue) {
            VStack(spacing: AppSpacing.medium) {
                Text(
                    "First-Order Reactor Design Equations"
                )
                .font(.headline)

                ViewThatFits(in: .horizontal) {
                    HStack(
                        spacing: AppSpacing.xxxLarge
                    ) {
                        pfrEquation

                        Divider()
                            .frame(height: 55)

                        cstrEquation
                    }

                    VStack(
                        spacing: AppSpacing.medium
                    ) {
                        pfrEquation

                        Divider()

                        cstrEquation
                    }
                }

                Text("V = v₀τ")
                    .font(
                        .system(
                            size: 21,
                            weight: .medium
                        )
                    )

                Text(
                    "Isothermal • Constant density • First-order reaction"
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
        }
        .frame(
            maxWidth:
                AppTheme.Layout.calculatorMaxWidth
        )
    }

    private var pfrEquation: some View {
        VStack(spacing: AppSpacing.xSmall) {
            Text("PFR")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("τ = −ln(1 − X) / k")
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )
        }
    }

    private var cstrEquation: some View {
        VStack(spacing: AppSpacing.xSmall) {
            Text("CSTR")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("τ = X / [k(1 − X)]")
                .font(
                    .system(
                        size: 21,
                        weight: .semibold
                    )
                )
        }
    }

    private func comparisonResults(
        _ result: ReactorComparisonResult
    ) -> some View {
        VStack(spacing: AppSpacing.large) {
            Divider()

            Text("Volume Comparison")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)

            volumeChart(result)

            CalculationResultCard(
                items: [
                    CalculationResultDisplayItem(
                        label: "PFR Volume",
                        value:
                            numberFormatter.format(
                                result.pfrVolume
                            ),
                        unit: "L"
                    ),
                    CalculationResultDisplayItem(
                        label: "CSTR Volume",
                        value:
                            numberFormatter.format(
                                result.cstrVolume
                            ),
                        unit: "L"
                    ),
                    CalculationResultDisplayItem(
                        label: "PFR Space Time",
                        value:
                            numberFormatter.format(
                                result.pfrSpaceTime
                            ),
                        unit: "min"
                    ),
                    CalculationResultDisplayItem(
                        label: "CSTR Space Time",
                        value:
                            numberFormatter.format(
                                result.cstrSpaceTime
                            ),
                        unit: "min"
                    ),
                    CalculationResultDisplayItem(
                        label: "Volume Difference",
                        value:
                            numberFormatter.format(
                                abs(
                                    result
                                        .volumeDifference
                                )
                            ),
                        unit: "L"
                    ),
                    CalculationResultDisplayItem(
                        label: "CSTR / PFR Ratio",
                        value:
                            numberFormatter.format(
                                result.volumeRatio
                            ),
                        unit: "×"
                    )
                ]
            )

            comparisonMessage(result)
        }
    }

    private func volumeChart(
        _ result: ReactorComparisonResult
    ) -> some View {
        Chart(result.chartData) { item in
            BarMark(
                x: .value(
                    "Reactor",
                    item.reactor.rawValue
                ),
                y: .value(
                    "Volume",
                    item.volume
                )
            )
            .annotation(position: .top) {
                Text(
                    numberFormatter.format(
                        item.volume
                    )
                )
                .font(.caption)
                .fontWeight(.semibold)
            }
        }
        .chartXAxisLabel("Reactor Type")
        .chartYAxisLabel("Reactor Volume (L)")
        .frame(height: 280)
        .padding(.horizontal)
        .accessibilityLabel(
            "PFR and CSTR reactor volume comparison chart"
        )
    }

    private func comparisonMessage(
        _ result: ReactorComparisonResult
    ) -> some View {
        CalculatorInfoCard(tint: .blue) {
            HStack(
                alignment: .top,
                spacing: AppSpacing.small
            ) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)
                    .accessibilityHidden(true)

                comparisonText(result)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
        }
    }

    @ViewBuilder
    private func comparisonText(
        _ result: ReactorComparisonResult
    ) -> some View {
        if result.cstrVolume > result.pfrVolume {
            Text(
                "For the selected conditions, the PFR requires " +
                "\(numberFormatter.format(result.cstrVolume - result.pfrVolume)) L " +
                "less reactor volume than the CSTR."
            )
        } else if result.pfrVolume >
                    result.cstrVolume {
            Text(
                "For the selected conditions, the CSTR requires " +
                "\(numberFormatter.format(result.pfrVolume - result.cstrVolume)) L " +
                "less reactor volume than the PFR."
            )
        } else {
            Text(
                "Both reactors require approximately the same volume."
            )
        }
    }

    private func calculateComparison() {
        clearResults()

        do {
            let enteredConversion =
                try InputValidator.parseNumber(
                    conversionInput,
                    fieldName: "Conversion"
                )

            let conversion =
                conversionFormat.fractionValue(
                    from: enteredConversion
                )

            let input = ReactorComparisonInput(
                rateConstant:
                    try InputValidator
                        .parseNumber(
                            rateConstantInput,
                            fieldName:
                                "Rate Constant"
                        ),
                conversion: conversion,
                flowRate:
                    try InputValidator
                        .parseNumber(
                            flowRateInput,
                            fieldName:
                                "Volumetric Flow Rate"
                        )
            )

            comparisonResult =
                try engine.compare(input: input)
        } catch let error as CalculationError {
            showCalculationError(error)
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func showCalculationError(
        _ error: CalculationError
    ) {
        let description =
            error.errorDescription ??
            "The reactor comparison could not be completed."

        if let suggestion =
            error.recoverySuggestion {
            errorMessage =
                "\(description) \(suggestion)"
        } else {
            errorMessage = description
        }
    }

    private func clearResults() {
        comparisonResult = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReactorComparisonView()
    }
}
