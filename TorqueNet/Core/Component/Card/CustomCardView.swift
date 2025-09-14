//
//  CustomCardView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 04/08/2025.
//

import SwiftUI

struct CustomCardView<Content: View>: View {
    let cardWidth: CGFloat
    let title: String?
    let bgColor: Color
    let contentColor: Color
    var subtitle: String?
    let strickThrough: Bool
    var onTap: (() -> Void)?
    let content: () -> (Content)?
    init(
        title: String? = nil,
        bgColor: Color = Color.theme.surfaceColor,
        contentColor: Color = Color.theme.onSurfaceColor,
        subtitle: String? = nil,
        strickThrough:Bool = false,
        cardWidth: CGFloat = .infinity,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.bgColor = bgColor
        self.contentColor = contentColor
        self.subtitle = subtitle
        self.strickThrough = strickThrough
        self.cardWidth = cardWidth
        self.onTap = onTap
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.custom("Exo2-Bold", size: 18))
                    .foregroundColor(contentColor)
                    .strikethrough(strickThrough, color: .gray)
            }

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.custom("Exo2-Regular", size: 16))
                    .foregroundColor(.gray)
                    .strikethrough(strickThrough, color: .gray)

            }

            content()
        }
        .padding()
        .background(bgColor)
        .cornerRadius(12)
        .frame(maxWidth: cardWidth)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
        .onTapGesture {
            onTap?()
        }
    }
}


struct CustomCardViewPreview: View {
    var body: some View {
          VStack(spacing: 20) {
              CustomCardView(title: "Profile", subtitle: "User Info") {
                  HStack {
                      Image(systemName: "person.crop.circle")
                          .resizable()
                          .frame(width: 40, height: 40)
                      VStack(alignment: .leading) {
                          Text("John Doe")
                          Text("john@example.com")
                              .font(.caption)
                              .foregroundColor(.gray)
                      }
                  }
              }

              CustomCardView(title: "Settings", onTap: {
                  print("Settings card tapped")
              }) {
                  Text("Tap to configure settings.")
                      .foregroundColor(.blue)
              }
          }
          .padding()
          .background(Color(UIColor.systemGroupedBackground))
      }
}


#Preview {
    CustomCardViewPreview()
}
