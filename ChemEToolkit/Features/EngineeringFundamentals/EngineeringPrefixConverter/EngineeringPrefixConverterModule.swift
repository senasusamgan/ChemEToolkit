import SwiftUI

enum EngineeringPrefixConverterModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .engineeringPrefixConverter,
            title: "Engineering Prefix Converter",
            subtitle: "Convert engineering powers and prefixes",
            category: .engineeringFundamentals,
            symbolName: "function",
            keywords: [
                "engineering prefix",
                "kilo mega giga",
                "milli micro nano",
                "power of ten",
                "scientific notation"
            ]
        ),
        destination: {
            EngineeringPrefixConverterView()
        }
    )
}
