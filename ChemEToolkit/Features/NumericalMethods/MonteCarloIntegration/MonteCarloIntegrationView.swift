import Foundation
import SwiftUI
struct MonteCarloIntegrationView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("Monte Carlo Integration").font(.largeTitle.bold())
  Text("Seeded estimate of ∫₀¹x²dx with 100,000 samples.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r = try MonteCarloIntegrationEngine().solve(.init(function: .square, lowerBound: 0, upperBound: 1)); output = String(format: "%.8g ± %.2g", r.integral, r.standardError);errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
