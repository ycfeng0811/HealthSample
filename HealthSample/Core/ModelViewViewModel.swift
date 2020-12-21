//
//  ModelViewViewModel.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/17.
//

import Foundation

protocol ModelViewViewModel {
  associatedtype Input
  associatedtype Output
  func transform(input: Input) -> Output
}
