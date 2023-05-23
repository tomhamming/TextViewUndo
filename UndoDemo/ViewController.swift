//
//  ViewController.swift
//  UndoDemo
//
//  Created by Tom Hamming on 5/23/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        
        var config = UIButton.Configuration.bordered()
        config.image = UIImage(systemName: "strikethrough")
        let strikeButton = UIButton(configuration: config)
        strikeButton.addTarget(self, action: #selector(toggleStrikethrough), for: .touchUpInside)
        container.addSubview(strikeButton)
        strikeButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        strikeButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        strikeButton.translatesAutoresizingMaskIntoConstraints = false
        
        config = UIButton.Configuration.bordered()
        config.title = "😀"
        let emojiButton = UIButton(configuration: config)
        emojiButton.addTarget(self, action: #selector(addEmoji), for: .touchUpInside)
        container.addSubview(emojiButton)
        emojiButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        emojiButton.leftAnchor.constraint(equalTo: strikeButton.rightAnchor, constant: 16).isActive = true
        emojiButton.translatesAutoresizingMaskIntoConstraints = false
        
        config = UIButton.Configuration.bordered()
        config.image = UIImage(systemName: "arrow.uturn.backward")
        let undoButton = UIButton(configuration: config)
        container.addSubview(undoButton)
        undoButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        undoButton.leftAnchor.constraint(equalTo: emojiButton.rightAnchor, constant: 16).isActive = true
        undoButton.addTarget(self, action: #selector(onUndo), for: .touchUpInside)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        
        config = UIButton.Configuration.bordered()
        config.image = UIImage(systemName: "arrow.uturn.forward")
        let redoButton = UIButton(configuration: config)
        container.addSubview(redoButton)
        redoButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        redoButton.leftAnchor.constraint(equalTo: undoButton.rightAnchor, constant: 16).isActive = true
        redoButton.addTarget(self, action: #selector(onUndo), for: .touchUpInside)
        redoButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.textView.inputAccessoryView = container
    }
    
    @objc func onUndo(_ sender: Any?) {
        guard self.textView.undoManager?.canUndo == true else { print("Can't undo!"); return }
        self.textView.undoManager?.undo()
    }
    
    @objc func onRedo(_ sender: Any?) {
        guard self.textView.undoManager?.canRedo == true else { print("Can't redo!"); return }
        self.textView.undoManager?.redo()
    }
    
    @objc func toggleStrikethrough(_ sender: Any?) {
        let selection = self.textView.selectedRange
        var longestRange = NSRange()
        let currVal = self.textView.textStorage.attribute(.strikethroughStyle, at: selection.location, effectiveRange: &longestRange) as? Int
        if let currVal, currVal == NSUnderlineStyle.single.rawValue {
            _removeStrikethrough(longestRange)
        }
        else if selection.length > 0 {
            _addStrikethrough(selection)
        }
    }
    
    func _removeStrikethrough(_ range: NSRange) {
        self.textView.textStorage.removeAttribute(.strikethroughStyle, range: range)
        
        self.textView.undoManager?.registerUndo(withTarget: self, handler: { vw in
            vw._addStrikethrough(range)
        })
    }
    
    func _addStrikethrough(_ range: NSRange) {
        self.textView.textStorage.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        self.textView.undoManager?.registerUndo(withTarget: self, handler: { vw in
            vw._removeStrikethrough(range)
        })
    }

    @objc func addEmoji(_ sender: Any?) {
        _addEmoji(at: self.textView.selectedRange.location)
    }

    func _addEmoji(at location: Int) {
        let smile = NSAttributedString(string: "😀", attributes: self.textView.typingAttributes)
        self.textView.textStorage.insert(smile, at: location)
        self.textView.selectedRange = NSRange(location: location + smile.length, length: 0)
        
        let range = NSRange(location: location, length: smile.length)
        self.textView.undoManager?.registerUndo(withTarget: self, handler: { vw in
            vw._removeEmoji(from: range)
        })
    }
    
    func _removeEmoji(from range: NSRange) {
        self.textView.textStorage.deleteCharacters(in: range)
        self.textView.selectedRange = NSRange(location: range.location, length: 0)
        
        self.textView.undoManager?.registerUndo(withTarget: self, handler: { vw in
            vw._addEmoji(at: range.location)
        })
    }
    
    
}

