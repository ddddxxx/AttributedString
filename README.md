## AttributedString

Value type and COW NSAttributedString.

### Quick Start

```swift
var attrString: AttributedString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
attrString[.foregroundColor] = .gray
attrString[.underlineStyle] = .patternDash
myLabel.attributedText = attrString as NSAttributedString
```
