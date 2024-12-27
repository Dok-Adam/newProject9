import SwiftUI

struct ContentView: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        ZStack {
            Color.red
            Color.yellow
                .clipShape(Circle())
                .frame(width: 200, height: 200)
                .blur(radius: 10)

            ZStack {
                Color.black

                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5, color: .yellow))
                    context.addFilter(.blur(radius: 18))

                    context.drawLayer { ctx in
                        if let baseCircle = context.resolveSymbol(id: 0) {
                            ctx.draw(baseCircle, in: CGRect(
                                x: (size.width - 130) / 2,
                                y: (size.height - 130) / 2,
                                width: 130,
                                height: 130
                            ))
                        }

                        if let dragCircle = context.resolveSymbol(id: 0) {
                            let rect = CGRect(
                                x: (size.width - 130) / 2 + offset.width,
                                y: (size.height - 130) / 2 + offset.height,
                                width: 130,
                                height: 130
                            )
                            ctx.draw(dragCircle, in: rect)
                        }
                    }
                } symbols: {
                    Circle()
                        .tag(0)
                }

                Circle()
                    .fill(.black)
                    .frame(width: 128)
                    .blendMode(.destinationOut)

                Circle()
                    .fill(.black)
                    .frame(width: 128)
                    .offset(offset)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()

            Image(systemName: "cloud.sun.rain.fill")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            offset = value.translation
                        }
                        .onEnded { _ in
                            isDragging = false
                            withAnimation(.interpolatingSpring(stiffness: 100, damping: 15)) {
                                offset = .zero
                            }
                        }
                )
        }
        .ignoresSafeArea()
    }
}




#Preview {
    ContentView()
}






