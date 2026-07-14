import Foundation

enum GasVariable: String, CaseIterable, Identifiable, Codable, Hashable {
    case pressure
    case volume
    case moles
    case temperature

    var id: String {
        rawValue
    }

    var symbol: String {
        switch self {
        case .pressure:
            return "P"
        case .volume:
            return "V"
        case .moles:
            return "n"
        case .temperature:
            return "T"
        }
    }

    var name: String {
        switch self {
        case .pressure:
            return "Pressure"
        case .volume:
            return "Volume"
        case .moles:
            return "Amount of Substance"
        case .temperature:
            return "Temperature"
        }
    }

    var unit: String {
        switch self {
        case .pressure:
            return "kPa"
        case .volume:
            return "L"
        case .moles:
            return "mol"
        case .temperature:
            return "K"
        }
    }
}

struct IdealGasInput: Equatable {
    let pressure: Double?
    let volume: Double?
    let moles: Double?
    let temperature: Double?

    func value(
        for variable: GasVariable
    ) -> Double? {
        switch variable {
        case .pressure:
            return pressure
        case .volume:
            return volume
        case .moles:
            return moles
        case .temperature:
            return temperature
        }
    }
}

struct IdealGasResult: Equatable {
    let variable: GasVariable
    let value: Double
}
