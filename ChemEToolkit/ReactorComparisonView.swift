import SwiftUI
import Charts

enum ComparisonConversionFormat: String, CaseIterable, Identifiable {
    case fraction = "Fraction"
    case percentage = "Percentage"

    var id: String { rawValue }

    var unit: String {
        switch self {
        case .fraction:
            return "0 – 1"

        case .percentage:
            return "%"
        }
    }
}

struct ReactorVolumeData: Identifiable {
    let id = UUID()
    let reactor: String
    let volume: Double
}

struct ReactorComparisonView: View {
    @State private var conversionFormat: ComparisonConversionFormat = .percentage

    @State private var rateConstantInput = ""
    @State private var conversionInput = ""
    @State private var flowRateInput = ""

    @State private var pfrSpaceTime: Double?
    @State private var cstrSpaceTime: Double?

    @State private var pfrVolume: Double?
    @State private var cstrVolume: Double?

    @State private var volumeDifference: Double?
    @State private var volumeRatio: Double?

    @State private var chartData: [ReactorVolumeData] = []
    @State private var errorMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 54))
                    .foregroundStyle(.blue)

                Text("CSTR–PFR Comparison")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Compare reactor volumes at the same conversion")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                equationCard

                VStack(alignment: .leading, spacing: 20) {
                    Text("Conversion Input Format")
                        .font(.headline)

                    Picker(
                        "Conversion Input Format",
                        selection: $conversionFormat
                    ) {
                        ForEach(
                            ComparisonConversionFormat.allCases
                        ) { format in
                            Text(format.rawValue)
                                .tag(format)
                        }
                    }
                    .pickerStyle(.segmented)

                    Divider()

                    numberField(
                        title: "Rate Constant",
                        symbol: "k",
                        unit: "1/min",
                        placeholder: "Enter rate constant",
                        text: $rateConstantInput
                    )

                    numberField(
                        title: "Conversion",
                        symbol: "X",
                        unit: conversionFormat.unit,
                        placeholder: conversionPlaceholder,
                        text: $conversionInput
                    )

                    numberField(
                        title: "Volumetric Flow Rate",
                        symbol: "v₀",
                        unit: "L/min",
                        placeholder: "Enter inlet volumetric flow rate",
                        text: $flowRateInput
                    )

                    Button {
                        calculateComparison()
                    } label: {
                        Label(
                            "Compare Reactors",
                            systemImage: "chart.bar.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    if !chartData.isEmpty {
                        comparisonResults
                    }

                    if !errorMessage.isEmpty {
                        Label(
                            errorMessage,
                            systemImage: "exclamationmark.triangle.fill"
                        )
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(24)
                .frame(maxWidth: 680)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.quaternary)
                )
            }
            .padding(40)
        }
        .frame(minWidth: 800, minHeight: 820)
        .navigationTitle("Reactor Comparison")
        .onChange(of: conversionFormat) { _, _ in
            conversionInput = ""
            clearResults()
        }
    }

    private var equationCard: some View {
        VStack(spacing: 12) {
            Text("First-Order Reactor Design Equations")
                .font(.headline)

            HStack(spacing: 40) {
                VStack(spacing: 6) {
                    Text("PFR")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Text("τ = −ln(1 − X) / k")
                        .font(.system(size: 21, weight: .semibold))
                }

                Divider()
                    .frame(height: 55)

                VStack(spacing: 6) {
                    Text("CSTR")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Text("τ = X / [k(1 − X)]")
                        .font(.system(size: 21, weight: .semibold))
                }
            }

            Text("V = v₀τ")
                .font(.system(size: 21, weight: .medium))

            Text(
                "Isothermal • Constant density • First-order reaction"
            )
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: 680)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.blue.opacity(0.08))
        )
    }

    private func numberField(
        title: String,
        symbol: String,
        unit: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(title) (\(symbol))")
                    .font(.headline)

                Spacer()

                Text(unit)
                    .foregroundStyle(.secondary)
            }

            TextField(
                placeholder,
                text: text
            )
            .textFieldStyle(.roundedBorder)
        }
    }

    private var conversionPlaceholder: String {
        switch conversionFormat {
        case .fraction:
            return "Enter a value greater than 0 and less than 1"

        case .percentage:
            return "Enter a value greater than 0 and less than 100"
        }
    }

    private var comparisonResults: some View {
        VStack(spacing: 22) {
            Divider()

            Text("Volume Comparison")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)

            Chart(chartData) { item in
                BarMark(
                    x: .value("Reactor", item.reactor),
                    y: .value("Volume", item.volume)
                )
                .annotation(position: .top) {
                    Text(formatNumber(item.volume))
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }
            .chartXAxisLabel("Reactor Type")
            .chartYAxisLabel("Reactor Volume (L)")
            .frame(height: 280)
            .padding(.horizontal)

            HStack(spacing: 14) {
                if let pfrVolume {
                    resultBox(
                        title: "PFR Volume",
                        value: pfrVolume,
                        unit: "L"
                    )
                }

                if let cstrVolume {
                    resultBox(
                        title: "CSTR Volume",
                        value: cstrVolume,
                        unit: "L"
                    )
                }
            }

            HStack(spacing: 14) {
                if let pfrSpaceTime {
                    resultBox(
                        title: "PFR Space Time",
                        value: pfrSpaceTime,
                        unit: "min"
                    )
                }

                if let cstrSpaceTime {
                    resultBox(
                        title: "CSTR Space Time",
                        value: cstrSpaceTime,
                        unit: "min"
                    )
                }
            }

            HStack(spacing: 14) {
                if let volumeDifference {
                    resultBox(
                        title: "Volume Difference",
                        value: volumeDifference,
                        unit: "L"
                    )
                }

                if let volumeRatio {
                    resultBox(
                        title: "CSTR / PFR Ratio",
                        value: volumeRatio,
                        unit: "×"
                    )
                }
            }

            comparisonMessage
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.green.opacity(0.1))
        )
    }

    private func resultBox(
        title: String,
        value: Double,
        unit: String
    ) -> some View {
        VStack(spacing: 7) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text(formatNumber(value))
                .font(.system(size: 25, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(unit)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 110)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background.opacity(0.6))
        )
    }

    @ViewBuilder
    private var comparisonMessage: some View {
        if let pfrVolume, let cstrVolume {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)

                if cstrVolume > pfrVolume {
                    Text(
                        "For the selected conditions, the PFR requires "
                        + "\(formatNumber(cstrVolume - pfrVolume)) L "
                        + "less reactor volume than the CSTR."
                    )
                } else if pfrVolume > cstrVolume {
                    Text(
                        "For the selected conditions, the CSTR requires "
                        + "\(formatNumber(pfrVolume - cstrVolume)) L "
                        + "less reactor volume than the PFR."
                    )
                } else {
                    Text(
                        "Both reactors require approximately the same volume."
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.blue.opacity(0.08))
            )
        }
    }

    private func calculateComparison() {
        clearResults()

        guard
            let rateConstant = parseNumber(rateConstantInput),
            let conversion = parseConversion(conversionInput),
            let flowRate = parseNumber(flowRateInput)
        else {
            errorMessage =
                "Please enter valid numerical values. "
                + "Conversion must be greater than zero "
                + "and less than one or 100%."
            return
        }

        guard rateConstant > 0 else {
            errorMessage =
                "The rate constant must be greater than zero."
            return
        }

        guard flowRate > 0 else {
            errorMessage =
                "The volumetric flow rate must be greater than zero."
            return
        }

        let calculatedPFRTau =
            -log(1 - conversion) / rateConstant

        let calculatedCSTRTau =
            conversion
            / (
                rateConstant
                * (1 - conversion)
            )

        let calculatedPFRVolume =
            flowRate * calculatedPFRTau

        let calculatedCSTRVolume =
            flowRate * calculatedCSTRTau

        pfrSpaceTime = calculatedPFRTau
        cstrSpaceTime = calculatedCSTRTau

        pfrVolume = calculatedPFRVolume
        cstrVolume = calculatedCSTRVolume

        volumeDifference =
            calculatedCSTRVolume - calculatedPFRVolume

        volumeRatio =
            calculatedCSTRVolume / calculatedPFRVolume

        chartData = [
            ReactorVolumeData(
                reactor: "PFR",
                volume: calculatedPFRVolume
            ),
            ReactorVolumeData(
                reactor: "CSTR",
                volume: calculatedCSTRVolume
            )
        ]
    }

    private func parseNumber(_ text: String) -> Double? {
        let normalizedText = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        return Double(normalizedText)
    }

    private func parseConversion(_ text: String) -> Double? {
        guard let enteredValue = parseNumber(text) else {
            return nil
        }

        let fraction: Double

        switch conversionFormat {
        case .fraction:
            fraction = enteredValue

        case .percentage:
            fraction = enteredValue / 100
        }

        guard fraction > 0, fraction < 1 else {
            return nil
        }

        return fraction
    }

    private func formatNumber(_ value: Double) -> String {
        value.formatted(
            .number.precision(
                .significantDigits(1...8)
            )
        )
    }

    private func clearResults() {
        pfrSpaceTime = nil
        cstrSpaceTime = nil

        pfrVolume = nil
        cstrVolume = nil

        volumeDifference = nil
        volumeRatio = nil

        chartData = []
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReactorComparisonView()
    }
}
