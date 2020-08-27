//
//  DesktopView.swift
//  ImportExport (macOS)
//
//  Created by Aaron Wright on 8/27/20.
//

import SwiftUI

struct DesktopView: View {
    
    @Environment(\.importFiles) var importAction
    @Environment(\.exportFiles) var exportAction
    
    @State private var message: String = "Hello, World!"
    
    var body: some View {
        VStack {
            GroupBox(label: Text("Message:")) {
                TextEditor(text: $message)
            }
            GroupBox {
                HStack {
                    Spacer()
                    
                    Button("Import") {
                        importAction(multipleOfType: [.plainText]) { result in
                            do {
                                guard let selectedFile: URL = try result?.get().first else { return }
                                guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                                
                                self.message = message
                            } catch {
                                // Handle failure.
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button("Export") {
                        do {
                            guard let tempURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("Message.txt") else { return }

                            try self.message.data(using: .utf8)?.write(to: tempURL)
                            
                            exportAction(moving: tempURL) { result in
                                if case .success = result {
                                    // Handle success.
                                } else {
                                    // Handle failure.
                                }
                            }
                        } catch {
                            Swift.print(error.localizedDescription)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .frame(width: 500, height: 500)
        .padding()
    }
    
}

struct DesktopView_Previews: PreviewProvider {
    
    static var previews: some View {
        DesktopView()
            .previewLayout(.sizeThatFits)
    }
    
}
