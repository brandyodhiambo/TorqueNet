//
//  AuthenticationRepositoryImpl.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 06/10/2025.
//
import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseFirestore

class AuthenticationRepositoryImpl: AuthenticationRepository {
    static let shared = AuthenticationRepositoryImpl()

    func signUpUser(name: String, email: String, password: String) async -> Result<AuthDataResult, FirebaseAuthError> {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            
            try await result.user.sendEmailVerification()
            
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "uid": result.user.uid,
                "name": name,
                "email": email.lowercased(),
                "createdAt": Timestamp(date: Date()),
            ]
            
            do {
                try await db.collection("users").document(result.user.uid).setData(userData)
                return .success(result)
            } catch {
                do {
                    try await result.user.delete()
                } catch {
                    return .failure(.custom("Failed to save user to database and failed to delete auth user: \(error.localizedDescription)"))
                }
                return .failure(.custom("Failed to save user to database: \(error.localizedDescription)"))
            }
        }
        catch let error as NSError {
            switch AuthErrorCode(rawValue: error.code) {
            case .invalidEmail:
                return .failure(.invalidEmail)
            case .weakPassword:
                return .failure(.weakPassword)
            case .emailAlreadyInUse:
                return .failure(.emailAlreadyInUse)
            default:
                return .failure(.custom(error.localizedDescription))
            }
        }
        catch {
            return .failure(.custom(error.localizedDescription))
        }
    }


    
    func signInUser(email: String, password: String) async -> Result<AuthDataResult, FirebaseAuthError> {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            try await result.user.reload()
            
            if result.user.isEmailVerified {
                return .success(result)
            } else {
                do {
                    try Auth.auth().signOut()
                } catch {
                    return .failure(.custom("Email not verified. Also failed to sign out: \(error.localizedDescription)"))
                }
                return .failure(.custom("Check your email for verification."))
            }
        } catch let error as NSError {
            switch AuthErrorCode(rawValue: error.code) {
            case .invalidEmail:
                return .failure(.invalidEmail)
            case .wrongPassword:
                return .failure(.wrongPassword)
            case .userNotFound:
                return .failure(.userNotFound)
            case .userDisabled:
                return .failure(.userDisabled)
            case .invalidCredential:
                return .failure(.invalidCredential)
            default:
                return .failure(.custom(error.localizedDescription))
            }
        } catch {
            return .failure(.custom(error.localizedDescription))
        }
    }

    
    func googleSignIn() async -> Result<AuthDataResult,FirebaseAuthError>{
        do{
            // google sign in
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                return .failure(FirebaseAuthError.custom("No firebase Client ID"))
            }
            
            // create google sigin In Configutation
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            //get rootView
            let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let rootViewController = await scene?.windows.first?.rootViewController else {
                return .failure(FirebaseAuthError.custom("This is not root view controller"))
            }
            
            // sign in authentication response
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting:rootViewController)
            let user = result.user
            guard let idToken = user.idToken?.tokenString else{
                return .failure(FirebaseAuthError.custom("no idToken found"))
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            let authResult = try await Auth.auth().signIn(with: credential)
            print("Google Auth success. OpenID \(authResult.user.uid)")
            return .success(authResult)
            
        }
        catch{
            return .failure(FirebaseAuthError.custom(error.localizedDescription))
        }
    }
    
    func forgotPassword(email: String) async -> Result<Bool,FirebaseAuthError>{
        do{
            let _ = try await Auth.auth().sendPasswordReset(withEmail: email)
            return .success(true)
        }
        catch{
            return .failure(FirebaseAuthError.custom(error.localizedDescription))
        }
    }
    
    func logoutUser() async -> Result<Bool,FirebaseAuthError>{
        do{
            try Auth.auth().signOut()
            return .success(true)
        }
        catch{
            return .failure(FirebaseAuthError.custom(error.localizedDescription))
        }
    }
    
    func deleteAccount() async -> Result<Bool,FirebaseAuthError>{
        do{
            try await Auth.auth().currentUser?.delete()
            return .success(true)
        }
        catch{
            return .failure(FirebaseAuthError.custom(error.localizedDescription))
        }
    }
    
}
