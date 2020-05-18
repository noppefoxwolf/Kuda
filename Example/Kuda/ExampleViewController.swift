//
//  ExampleViewController.swift
//  Kuda_Example
//
//  Created by Tomoya Hirano on 2020/05/18.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import SwiftUI

class ExampleViewController: UIHostingController<ExampleView> {}

internal struct ExampleView: View {
    var body: some View {
        Text("Hello world!")
    }
}
