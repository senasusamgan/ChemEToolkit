import SwiftUI

struct AppModule: Identifiable {
    let metadata: ModuleMetadata
    private let destinationBuilder: @MainActor () -> AnyView

    var id: ModuleID {
        metadata.id
    }

    init<Destination: View>(
        metadata: ModuleMetadata,
        destination: @escaping @MainActor () -> Destination
    ) {
        self.metadata = metadata
        self.destinationBuilder = {
            AnyView(destination())
        }
    }

    @MainActor
    func makeDestination() -> AnyView {
        destinationBuilder()
    }
}
