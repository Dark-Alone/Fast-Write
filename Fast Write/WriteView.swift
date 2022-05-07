//
//  ViewController.swift
//  Fast Write
//
//  Created by Марк Акиваев on 26/09/2019.
//  Copyright © 2019 Марк Акиваев. All rights reserved.
//

import Cocoa

class Settings {
    var font: NSFont
    var textColor: NSColor
    var backgroundColor: NSColor
    var trueColor: NSColor
    var falseColor: NSColor
    
    var mainSettings: [NSAttributedString.Key : Any] {
        return [.font: font,
                .foregroundColor: textColor]
    }
    
//    let shared = Settings()
    init() {
        font = .systemFont(ofSize: 14)
        textColor = .white
        backgroundColor = .darkGray
        trueColor = NSColor(red: 0.2, green: 1, blue: 0.2, alpha: 1)
        falseColor = NSColor(red: 1, green: 0.2, blue: 0.2, alpha: 1)
    }
    
    
}

enum WordType: Int {
    case word = 0, separator, number
}

struct Word {
    let word: String
    let wordType: WordType
    let range: NSRange
}

class ViewController: NSViewController, NSTextViewDelegate {
    
    let settings = Settings()
    
    @IBOutlet weak var label: NSTextField!
    @IBOutlet var writer: NSTextView!
    
    let separators = [".", ";", ",", " ", "\"", "\\", "/", "<", ">", "?", "!", "@", ":", "|", "[", "]", "}", "{", "№"]
    var words: [Word] = []
    
    var text: String = "" {
        didSet {
            separateText()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writer.typingAttributes = settings.mainSettings
        text = "some text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabelsome text for textLabel"
        let _ = "Test string for big ping."
        label.attributedStringValue = NSAttributedString(string: text, attributes: settings.mainSettings)
        label.backgroundColor = settings.backgroundColor
        writer.backgroundColor = settings.backgroundColor
        
        
        writer.delegate = self
        
        separateText()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func separateText() {
        words.removeAll()
        var startIndex = 0
        var lastIndex = 0
        for (i, char) in text.enumerated() {
            let sep = separators.contains(String(char))
            let num = String(char)

            if separators.contains(String(char)) {
                if lastIndex != (i - 1) {
                    createWord(location: startIndex, length: i - startIndex, wordType: .word)
                }
                createWord(location: i, length: 1, wordType: .separator)
                startIndex = i + 1
                lastIndex = i
            }
        }
        words.forEach {
            print("word: ", $0.word)
            print("type is", terminator: " ")
            switch $0.wordType {
            case .number:
                print("number")
            case .separator:
                print("separator")
            case .word:
                print("word")
            }
            print("range from \($0.range.location) with length \($0.range.length)")
            print("--------------")
        }
    }
    
    func createWord(location: Int, length: Int, wordType: WordType/*, lastIndex: inout Int*/) {
        let nsrange = NSRange(location: location, length: length)
        if let range = Range(nsrange, in: text) {
            let wordText = String(text[range])
            let word = Word(word: wordText, wordType: wordType, range: nsrange)
            words.append(word)
        }
    }
    
    func textDidChange(_ notification: Notification) {
        print("text changedd!")
    }
}

