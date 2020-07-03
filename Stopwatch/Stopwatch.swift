//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by Maruf Howlader on 7/2/20.
//  Copyright © 2020 Creative Young. All rights reserved.
//

import Foundation

class Stopwatch: NSObject {
  var counter: Double
  var timer: Timer
  
  override init() {
    counter = 0.0
    timer = Timer()
  }
}

