//
//  CustomDialogView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 04/08/2025.
//

import SwiftUI

struct CustomAlertDialogView: View {
    @Binding var isPresented: Bool
    var title: String
    var text: String
    var confirmButtonText: String = ""
    var dismissButtonText: String
    var imageName: String
    var onDismiss: () -> Void
    var onConfirmation: () -> Void

    var body: some View {
        ZStack {

            if isPresented {
                // Background overlay
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                       // isPresented = false // Dismiss when tapping outside
                    }

                // Alert dialog
                VStack(spacing: 20) {
                    
                    Text(title)
                        .font(.custom("Exo2-Medium", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.theme.primaryColor)

                    if !imageName.isEmpty {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                    
                    
                    Text(text)
                        .font(.custom("Exo2-Light", size: 17))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.theme.onSurfaceColor)

                    HStack {

                        if !dismissButtonText.isEmpty {
                            CustomSecondayButtonView(
                                buttonName: dismissButtonText,
                                height:45,
                                onTap:{
                                    onDismiss()
                                    isPresented = false
                                }
                            )
                        }
                        
                        

                    if !confirmButtonText.isEmpty {
                        CustomButtonView(
                            buttonName: confirmButtonText,
                            height:45,
                            onTap: {
                                onConfirmation()
                                isPresented = false
                            }
                        )
                    }
                  }
                }
                .padding()
                .background(Color.theme.surfaceColor)
                .cornerRadius(8)
                .shadow(radius: 15)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.95)
                .padding()
            }
        }
    }
}

struct CustomAlertDialogPreview: View {
    @State private var showAlert = true
    @State private var responseText = ""
    
    var body: some View {
        CustomAlertDialogView(
            isPresented: .constant(showAlert),
            title: "Add Car",
            text: "Are you sure you want to add this car?",
            confirmButtonText: "Proceed",
            dismissButtonText: "Cancel",
            imageName: "",
            onDismiss: {
                
            },
            onConfirmation: {
                
            }
        )
        
    }
}


#Preview {
    CustomAlertDialogPreview()
}
