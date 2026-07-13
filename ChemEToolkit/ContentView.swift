import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Image(systemName: "atom")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text("ChemE Toolkit")
                    .font(.system(size: 34, weight: .bold))

                Text("Chemical Engineering Calculator")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {

                    NavigationLink {
                        UnitConverterView()
                    } label: {
                        ModuleRow(
                            title: "Unit Converter",
                            icon: "arrow.left.arrow.right"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        IdealGasView()
                    } label: {
                        ModuleRow(
                            title: "Ideal Gas Calculator",
                            icon: "flask.fill"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        ConcentrationView()
                    } label: {
                        ModuleRow(
                            title: "Solution Concentration",
                            icon: "drop.fill"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        MassBalanceView()
                    } label: {
                        ModuleRow(
                            title: "Mass Balance",
                            icon: "arrow.triangle.merge"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        ReactorView()
                    } label: {
                        ModuleRow(
                            title: "Reactor Design",
                            icon: "gearshape.2.fill"
                        )
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: 380)
            }
            .padding(40)
            .frame(
                minWidth: 520,
                minHeight: 560
            )
            .navigationTitle("")
        }
    }
}

struct ModuleRow: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 32)

            Text(title)
                .font(.headline)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.quaternary)
        )
        .contentShape(Rectangle())
    }
}

#Preview {
    ContentView()
}
