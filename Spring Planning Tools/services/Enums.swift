//
//  Enums.swift
//  Spring Planning Tools
//
//  Created by mendel bellaiche on 23/06/2020.
//  Copyright © 2020 mendel bellaiche. All rights reserved.
//

import Foundation
import UIKit

enum Etat: Int {
    case done = 2
    case inprogress = 1
    case undone = 0
}

enum Priority: Int {
    case urgent = 3
    case high = 2
    case medium = 1
    case low = 0
}
