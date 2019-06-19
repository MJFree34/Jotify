//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import MultilineTextField
import CloudKit

class WriteNoteController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    let database = CKContainer.default().privateCloudDatabase
        
    lazy var inputTextView: MultilineTextField = {
        let frame = CGRect(x: 0, y: 100, width: screenWidth, height: screenHeight)
        let textField = MultilineTextField(frame: frame)
        textField.backgroundColor = .clear
        textField.placeholderColor = .white
        textField.textColor = .white
        textField.isEditable = true
        textField.isPlaceholderScrollEnabled = true
        textField.leftViewOrigin = CGPoint(x: 8, y: 8)
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        textField.placeholder = "Write it down..."
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addGradient()
        setupView()
    }
    
    func setupView() {
        view.clipsToBounds = true
        inputTextView.delegate = self
        
        view.addSubview(inputTextView)
    }
    
    func addGradient() {
        Colors.shared.themeColor = GradientThemes.NeonLife
        self.view.setGradient()
    }
    
    @objc func handleSend() {
        
        if inputTextView.text == "" {
            
        } else {
            let colorNameArray = ["systemRed", "systemBlue", "systemGreen", "systemPink", "systemOrange", "systemPurple", "systemTeal", "systemYellow"]
            let color = colorNameArray.randomElement()!
            let timeCreated = Date.timeIntervalSinceReferenceDate
            saveNote(note: inputTextView.text, timeCreated: timeCreated, color: color)
            inputTextView.text = ""
        }
    }
    
    func saveNote(note: String, timeCreated: Double, color: String) {
        let newNote = CKRecord(recordType: "note")
        newNote.setValue(note, forKey: "content")
        newNote.setValue(timeCreated, forKey: "timeCreated")
        newNote.setValue(color, forKey: "color")
        
        database.save(newNote) { (record, error) in
            guard record != nil else { return }
            print("saved record with note \(String(describing: record?.object(forKey: "content")))")
            print("saved record with time \(String(describing: record?.object(forKey: "timeCreated")))")
        }
        
//        let savedNoteController = SavedNoteController()
//        savedNoteController.fetchNotes()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        
        //dismiss keyboard on return key
        textView.resignFirstResponder()
        handleSend()
        
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
