//
//  DocumentViewController.swift
//  Syntax_iOS
//
//  Created by Joey
//

import UIKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var documentNameLabel: UILabel!
    
    var document: UIDocument?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                // Display the content of the document, e.g.:
                self.documentNameLabel.text = self.document?.fileURL.lastPathComponent
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let theme = DarkTheme()
        let lexer = SwiftLexer(theme)
        let syntaxVC = SyntaxViewController(lexer: lexer)
        addChild(syntaxVC)
        syntaxVC.view.frame = self.view.frame
        view.addSubview(syntaxVC.view)
        syntaxVC.didMove(toParent: self)
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}
