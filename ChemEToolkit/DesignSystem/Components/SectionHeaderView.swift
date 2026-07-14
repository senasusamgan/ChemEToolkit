import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let subtitle: String?

    var actionTitle: String?
    var action: (() -> Void)?

    init(
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.medium) {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.xxSmall
            ) {
                Text(title)
                    .font(.title2.bold())

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if let actionTitle, let action {
                Button(
                    actionTitle,
                    action: action
                )
                .buttonStyle(.borderless)
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}
