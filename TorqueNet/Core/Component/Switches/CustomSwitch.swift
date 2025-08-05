//
//  CustomSwitch.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct CustomSwitch: View {
    @Binding var isOn: Bool
    var onTap: (Bool) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(isOn ? Color.green : Color.gray.opacity(0.5))
                .frame(width: 50, height: 30)
                .animation(.easeInOut(duration: 0.2), value: isOn)

            Circle()
                .fill(Color.white)
                .frame(width: 26, height: 26)
                .offset(x: isOn ? 10 : -10)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                .animation(.easeInOut(duration: 0.2), value: isOn)
        }
        .onTapGesture {
            withAnimation {
                isOn.toggle()
                onTap(isOn)
            }
        }
    }
}

#Preview {
    CustomSwitch(
        isOn: .constant(true),
        onTap: { isOn in
        }
    )
}
