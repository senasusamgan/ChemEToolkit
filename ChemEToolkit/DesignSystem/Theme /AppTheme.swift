import SwiftUI

enum AppTheme {
    enum Colors {
        static let accent = Color.accentColor

        static let surface =
            Color.primary.opacity(0.05)

        static let elevatedSurface =
            Color.primary.opacity(0.075)

        static let border =
            Color.primary.opacity(0.09)

        static let infoSurface =
            Color.blue.opacity(0.08)

        static let successSurface =
            Color.green.opacity(0.12)

        static let errorSurface =
            Color.red.opacity(0.08)

        static let warningSurface =
            Color.orange.opacity(0.10)
    }

    enum Radius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
    }

    enum Layout {
        static let calculatorMaxWidth: CGFloat = 680
        static let contentMaxWidth: CGFloat = 1_180

        static let moduleCardMinimumWidth: CGFloat = 280
        static let moduleCardMaximumWidth: CGFloat = 430

        static let categoryCardMinimumWidth: CGFloat = 270
        static let categoryCardMaximumWidth: CGFloat = 410

        static let pageHorizontalPadding: CGFloat = 20
        static let pageVerticalPadding: CGFloat = 32
        static let iconSize: CGFloat = 54
    }
}
