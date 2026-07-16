import SwiftUI

enum HeatExchangeCSTRModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .heatExchangeCSTR,
            title: "Heat-Exchange CSTR",
            subtitle: "Size a non-isothermal CSTR with coolant heat removal",
            category: .reactionEngineering,
            symbolName: "snowflake.circle.fill",
            keywords: [
                "heat exchange CSTR",
                "non-isothermal CSTR",
                "coolant",
                "energy balance",
                "reactor sizing"
            ]
        ),
        destination: {
            HeatExchangeCSTRView()
        }
    )
}
