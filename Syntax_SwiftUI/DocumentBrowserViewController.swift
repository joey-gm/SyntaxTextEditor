//
//  DocumentBrowserViewController.swift
//  Syntax_SwiftUI
//
//  Created by Joey
//

import UIKit
import SwiftUI

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        let doc = Document()
        let url = doc.fileURL
        
        doc.save(to: url, for: .forCreating) { saveSuccess in
            guard saveSuccess else {
                importHandler(nil, .none)
                return
            }
            
            doc.close(completionHandler: { (closeSuccess) in
                
                // Make sure the document closed successfully.
                guard closeSuccess else {
                    importHandler(nil, .none)
                    return
                }
                // Pass the document's temporary URL to the import handler.
                importHandler(url, .move)
            })
        }
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        let document = Document(fileURL: documentURL)
        
        // Access the document
        document.open(completionHandler: { success in
            if success {
                // Display the content of the document:
                let view = DocumentView(document: document, dismiss: {
                    self.closeDocument(document)
                })
                
                let documentViewController = UIHostingController(rootView: view)
                self.present(documentViewController, animated: true, completion: nil)
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    
    func closeDocument(_ document: Document) {
        dismiss(animated: true) {
            document.close(completionHandler: nil)
        }
    }
}

