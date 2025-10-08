//
//  FetchState.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 08/10/2025.
//

enum FetchState: Comparable{
    case good
    case isLoading
    case noResults
    case error(String)
}
