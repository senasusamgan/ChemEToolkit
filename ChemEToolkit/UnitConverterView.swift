import SwiftUI

enum ConversionCategory: String, CaseIterable, Identifiable {
    case temperature = "Temperature"
    case pressure = "Pressure"
    case volume = "Volume"
    case mass = "Mass"
    case energy = "Energy"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .temperature:
            return "thermometer.medium"
        case .pressure:
            return "gauge.with.dots.needle.50percent"
        case .volume:
            return "cube.fill"
        case .mass:
            return "scalemass.fill"
        case .energy:
            return "bolt.fill"
        }
    }

    var units: [String] {
        switch self {
        case .temperature:
            return ["Celsius", "Kelvin", "Fahrenheit"]

        case .pressure:
            return ["Pascal", "Kilopascal", "Bar", "Atmosphere"]

        case .volume:
            return ["Cubic Meter", "Liter", "Milliliter"]

        case .mass:
            return ["Kilogram", "Gram", "Milligram"]

        case .energy:
            return ["Joule", "Kilojoule", "Kilocalorie"]
        }
    }
}

struct UnitConverterView: View {
    @State private var selectedCategory: ConversionCategory = .temperature
    @State private var inputValue = ""

    @State private var fromUnit = "Celsius"
    @State private var toUnit = "Kelvin"

    @State private var result: Double?
    @State private var errorMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: selectedCategory.icon)
                    .font(.system(size: 54))
                    .foregroundStyle(.blue)

                Text("Unit Converter")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Convert common engineering units")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 18) {
                    Text("Category")
                        .font(.headline)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ConversionCategory.allCases) { category in
                            Text(category.rawValue)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.segmented)

                    Divider()

                    Text("Value")
                        .font(.headline)

                    TextField("Enter a numerical value", text: $inputValue)
                        .textFieldStyle(.roundedBorder)

                    HStack(spacing: 20) {
                        unitPicker(
                            title: "From",
                            selection: $fromUnit
                        )

                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundStyle(.secondary)

                        unitPicker(
                            title: "To",
                            selection: $toUnit
                        )
                    }

                    Button {
                        convert()
                    } label: {
                        Label(
                            "Convert",
                            systemImage: "arrow.left.arrow.right"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    if let result {
                        resultCard(result)
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
                .frame(maxWidth: 620)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.quaternary)
                )
            }
            .padding(40)
        }
        .frame(minWidth: 720, minHeight: 650)
        .navigationTitle("Unit Converter")
        .onChange(of: selectedCategory) { _, newCategory in
            updateUnits(for: newCategory)
        }
    }

    private func unitPicker(
        title: String,
        selection: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            Picker(title, selection: selection) {
                ForEach(selectedCategory.units, id: \.self) { unit in
                    Text(unit)
                        .tag(unit)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity)
        }
    }

    private func resultCard(_ result: Double) -> some View {
        VStack(spacing: 8) {
            Text("Result")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(
                result.formatted(
                    .number.precision(.fractionLength(0...6))
                )
            )
            .font(.system(size: 32, weight: .bold))

            Text(toUnit)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.blue.opacity(0.1))
        )
    }

    private func updateUnits(
        for category: ConversionCategory
    ) {
        let units = category.units

        fromUnit = units[0]
        toUnit = units.count > 1 ? units[1] : units[0]

        result = nil
        errorMessage = ""
    }

    private func convert() {
        errorMessage = ""

        let normalizedInput = inputValue.replacingOccurrences(
            of: ",",
            with: "."
        )

        guard let value = Double(normalizedInput) else {
            result = nil
            errorMessage = "Please enter a valid numerical value."
            return
        }

        switch selectedCategory {
        case .temperature:
            result = convertTemperature(value)

        case .pressure:
            result = convertLinear(
                value: value,
                factors: pressureFactors
            )

        case .volume:
            result = convertLinear(
                value: value,
                factors: volumeFactors
            )

        case .mass:
            result = convertLinear(
                value: value,
                factors: massFactors
            )

        case .energy:
            result = convertLinear(
                value: value,
                factors: energyFactors
            )
        }
    }

    private func convertLinear(
        value: Double,
        factors: [String: Double]
    ) -> Double? {
        guard
            let fromFactor = factors[fromUnit],
            let toFactor = factors[toUnit]
        else {
            errorMessage = "The selected unit is not supported."
            return nil
        }

        let baseValue = value * fromFactor
        return baseValue / toFactor
    }

    private func convertTemperature(
        _ value: Double
    ) -> Double {
        let valueInCelsius: Double

        switch fromUnit {
        case "Celsius":
            valueInCelsius = value

        case "Kelvin":
            valueInCelsius = value - 273.15

        case "Fahrenheit":
            valueInCelsius = (value - 32) * 5 / 9

        default:
            valueInCelsius = value
        }

        switch toUnit {
        case "Celsius":
            return valueInCelsius

        case "Kelvin":
            return valueInCelsius + 273.15

        case "Fahrenheit":
            return valueInCelsius * 9 / 5 + 32

        default:
            return valueInCelsius
        }
    }

    private let pressureFactors: [String: Double] = [
        "Pascal": 1,
        "Kilopascal": 1_000,
        "Bar": 100_000,
        "Atmosphere": 101_325
    ]

    private let volumeFactors: [String: Double] = [
        "Cubic Meter": 1,
        "Liter": 0.001,
        "Milliliter": 0.000001
    ]

    private let massFactors: [String: Double] = [
        "Kilogram": 1,
        "Gram": 0.001,
        "Milligram": 0.000001
    ]

    private let energyFactors: [String: Double] = [
        "Joule": 1,
        "Kilojoule": 1_000,
        "Kilocalorie": 4_184
    ]
}

#Preview {
    NavigationStack {
        UnitConverterView()
    }
}
