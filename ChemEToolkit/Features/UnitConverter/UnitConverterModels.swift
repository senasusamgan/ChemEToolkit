import Foundation

enum ConversionCategory: String, CaseIterable, Identifiable, Codable, Hashable {
    case temperature
    case pressure
    case volume
    case mass
    case energy

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .temperature:
            return "Temperature"
        case .pressure:
            return "Pressure"
        case .volume:
            return "Volume"
        case .mass:
            return "Mass"
        case .energy:
            return "Energy"
        }
    }

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

    var units: [ConversionUnit] {
        switch self {
        case .temperature:
            return [
                .celsius,
                .kelvin,
                .fahrenheit
            ]

        case .pressure:
            return [
                .pascal,
                .kilopascal,
                .bar,
                .atmosphere
            ]

        case .volume:
            return [
                .cubicMeter,
                .liter,
                .milliliter
            ]

        case .mass:
            return [
                .kilogram,
                .gram,
                .milligram
            ]

        case .energy:
            return [
                .joule,
                .kilojoule,
                .kilocalorie
            ]
        }
    }
}

enum ConversionUnit: String, CaseIterable, Identifiable, Codable, Hashable {
    case celsius
    case kelvin
    case fahrenheit

    case pascal
    case kilopascal
    case bar
    case atmosphere

    case cubicMeter
    case liter
    case milliliter

    case kilogram
    case gram
    case milligram

    case joule
    case kilojoule
    case kilocalorie

    var id: String {
        rawValue
    }

    var name: String {
        switch self {
        case .celsius:
            return "Celsius"
        case .kelvin:
            return "Kelvin"
        case .fahrenheit:
            return "Fahrenheit"

        case .pascal:
            return "Pascal"
        case .kilopascal:
            return "Kilopascal"
        case .bar:
            return "Bar"
        case .atmosphere:
            return "Atmosphere"

        case .cubicMeter:
            return "Cubic Meter"
        case .liter:
            return "Liter"
        case .milliliter:
            return "Milliliter"

        case .kilogram:
            return "Kilogram"
        case .gram:
            return "Gram"
        case .milligram:
            return "Milligram"

        case .joule:
            return "Joule"
        case .kilojoule:
            return "Kilojoule"
        case .kilocalorie:
            return "Kilocalorie"
        }
    }

    var symbol: String {
        switch self {
        case .celsius:
            return "°C"
        case .kelvin:
            return "K"
        case .fahrenheit:
            return "°F"

        case .pascal:
            return "Pa"
        case .kilopascal:
            return "kPa"
        case .bar:
            return "bar"
        case .atmosphere:
            return "atm"

        case .cubicMeter:
            return "m³"
        case .liter:
            return "L"
        case .milliliter:
            return "mL"

        case .kilogram:
            return "kg"
        case .gram:
            return "g"
        case .milligram:
            return "mg"

        case .joule:
            return "J"
        case .kilojoule:
            return "kJ"
        case .kilocalorie:
            return "kcal"
        }
    }

    var category: ConversionCategory {
        switch self {
        case .celsius,
             .kelvin,
             .fahrenheit:
            return .temperature

        case .pascal,
             .kilopascal,
             .bar,
             .atmosphere:
            return .pressure

        case .cubicMeter,
             .liter,
             .milliliter:
            return .volume

        case .kilogram,
             .gram,
             .milligram:
            return .mass

        case .joule,
             .kilojoule,
             .kilocalorie:
            return .energy
        }
    }

    var linearFactorToBaseUnit: Double? {
        switch self {
        case .celsius,
             .kelvin,
             .fahrenheit:
            return nil

        case .pascal:
            return 1
        case .kilopascal:
            return 1_000
        case .bar:
            return 100_000
        case .atmosphere:
            return 101_325

        case .cubicMeter:
            return 1
        case .liter:
            return 0.001
        case .milliliter:
            return 0.000001

        case .kilogram:
            return 1
        case .gram:
            return 0.001
        case .milligram:
            return 0.000001

        case .joule:
            return 1
        case .kilojoule:
            return 1_000
        case .kilocalorie:
            return 4_184
        }
    }
}

struct UnitConversionResult: Equatable {
    let inputValue: Double
    let outputValue: Double
    let fromUnit: ConversionUnit
    let toUnit: ConversionUnit
}
