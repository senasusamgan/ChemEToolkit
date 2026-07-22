import Foundation
import SwiftUI
struct AdaptiveSimpsonIntegrationView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("Adaptive Simpson Integration").font(.largeTitle.bold())
  Text("Integral of x² from 0 to 1. Values are dimensionless.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r = try AdaptiveSimpsonIntegrationEngine().solve(.init(function: .square, lowerBound: 0, upperBound: 1)); output = String(format: "%.10g", r.integral);errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
