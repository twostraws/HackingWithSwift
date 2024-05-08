//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Paul Hudson on 08/05/2024.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        HStack(alignment: .lastTextBaseline) {
//            Text("Live")
//                .font(.caption)
//            Text("long")
//            Text("and")
//                .font(.title)
//            Text("prosper")
//                .font(.largeTitle)
//        }
//    }
//}

//struct ContentView: View {
//    var body: some View {
//        VStack(alignment: .leading) {
//            ForEach(0..<10) { position in
//                Text("Number \(position)")
//                    .alignmentGuide(.leading) { _ in Double(position) * -10 }
//            }
//        }
//        .background(.red)
//        .frame(width: 400, height: 400)
//        .background(.blue)
//    }
//}

//extension VerticalAlignment {
//    struct MidAccountAndName: AlignmentID {
//        static func defaultValue(in context: ViewDimensions) -> CGFloat {
//            context[.top]
//        }
//    }
//
//    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
//}
//
//struct ContentView: View {
//    var body: some View {
//        HStack(alignment: .midAccountAndName) {
//            VStack {
//                Text("@twostraws")
//                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
//                Image(.paulHudson)
//                    .resizable()
//                    .frame(width: 64, height: 64)
//            }
//
//            VStack {
//                Text("Full name:")
//                Text("PAUL HUDSON")
//                    .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
//                    .font(.largeTitle)
//            }
//        }
//    }
//}

//struct ContentView: View {
//    var body: some View {
//        Text("Hello, world!")
//            .position(x: 100, y: 100)
//            .background(.red)
//    }
//}

//struct ContentView: View {
//    var body: some View {
//        HStack {
//            Text("IMPORTANT")
//                .frame(width: 200)
//                .background(.blue)
//
//            GeometryReader { proxy in
//                Image(.example)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: proxy.size.width * 0.8)
//                    .frame(width: proxy.size.width, height: proxy.size.height)
//            }
//        }
//    }
//}

//struct OuterView: View {
//    var body: some View {
//        VStack {
//            Text("Top")
//            InnerView()
//                .background(.green)
//            Text("Bottom")
//        }
//    }
//}
//
//struct InnerView: View {
//    var body: some View {
//        HStack {
//            Text("Left")
//            GeometryReader { proxy in
//                Text("Center")
//                    .background(.blue)
//                    .onTapGesture {
//                        print("Global center: \(proxy.frame(in: .global).midX) x \(proxy.frame(in: .global).midY)")
//                        print("Custom center: \(proxy.frame(in: .named("Custom")).midX) x \(proxy.frame(in: .named("Custom")).midY)")
//                        print("Local center: \(proxy.frame(in: .local).midX) x \(proxy.frame(in: .local).midY)")
//                    }
//            }
//            .background(.orange)
//            Text("Right")
//        }
//    }
//}
//
//struct ContentView: View {
//    var body: some View {
//        OuterView()
//            .background(.red)
//            .coordinateSpace(name: "Custom")
//    }
//}

//struct ContentView: View {
//    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
//
//    var body: some View {
//        GeometryReader { fullView in
//            ScrollView {
//                ForEach(0..<50) { index in
//                    GeometryReader { proxy in
//                        Text("Row #\(index)")
//                            .font(.title)
//                            .frame(maxWidth: .infinity)
//                            .background(colors[index % 7])
//                            .rotation3DEffect(.degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
//                    }
//                    .frame(height: 40)
//                }
//            }
//        }
//    }
//}

//struct ContentView: View {
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 0) {
//                ForEach(1..<20) { num in
//                    GeometryReader { proxy in
//                        Text("Number \(num)")
//                            .font(.largeTitle)
//                            .padding()
//                            .background(.red)
//                            .rotation3DEffect(.degrees(-proxy.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
//                            .frame(width: 200, height: 200)
//                    }
//                    .frame(width: 200, height: 200)
//                }
//            }
//        }
//    }
//}

struct ContentView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(1..<20) { num in
                    Text("Number \(num)")
                        .font(.largeTitle)
                        .padding()
                        .background(.red)
                        .frame(width: 200, height: 200)
                        .visualEffect { content, proxy in
                            content
                                .rotation3DEffect(.degrees(-proxy.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                        }

                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    ContentView()
}
