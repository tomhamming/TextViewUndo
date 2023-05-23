# TextViewUndo
Demonstrating a problem with NSUndoManager and UITextView

This project demonstrates an issue posted on Stack Overflow [here](https://stackoverflow.com/questions/76308466/how-can-i-integrate-my-own-text-changes-into-uitextviews-undo-manager) and on Apple forums [here](https://developer.apple.com/forums/thread/730221). Basically, if you programmatically change the text of a `UITextView`, its undo manager seems to clear its undo stack, even if you undo your changes properly.

To repro:

1. Run project
2. Type some changes in the text view
3. Tap the Emoji button, and an emoji is inserted
4. Type some more changes
5. Begin undoing all your changes

You can undo back to the addition of the emoji (because that operation is done through the undo manager), but no further. If at step 3 you select some text and add a strikethrough, though, you can undo all of your changes.
