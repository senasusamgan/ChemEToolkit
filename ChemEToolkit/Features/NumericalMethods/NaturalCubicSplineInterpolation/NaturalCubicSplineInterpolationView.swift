import Foundation
import SwiftUI
struct NaturalCubicSplineInterpolationView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("Natural Cubic Spline Interpolation").font(.largeTitle.bold())
  Text("Natural boundaries; query must remain inside the tabulated range.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r = try NaturalCubicSplineInterpolationEngine().solve(.init(xValues: [0,1,2,3], yValues: [0,1,4,9], query: 1.5)); output = String(format: "%.10g", r.value);errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
