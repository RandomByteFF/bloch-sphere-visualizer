class_name Token

enum TokenType { 
    VALUE, 
    OPERATOR, 
    BRACKET_OPEN,
    BRACKET_CLOSE,
    FUNCTION,
}

var type: TokenType
var value: String
var precedence : int

@warning_ignore("shadowed_variable")
func _init(type: TokenType, value: String, precedence : int = 0):
    self.type = type
    self.value = value
    self.precedence = precedence
