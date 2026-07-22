import Foundation
import SwiftUI
struct GradientDescentOptimizationView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("Gradient Descent Optimization").font(.largeTitle.bold())
  Text("Line search minimizes a supported dimensionless two-variable objective.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r=try GradientDescentOptimizationEngine().solve(.init(objective:.quadratic,initialPoint:[0,0]));output=r.optimum.map{String(format:"%.8g",$0)}.joined(separator:", ");errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
