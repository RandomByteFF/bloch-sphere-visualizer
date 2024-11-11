class_name Token

enum TokenType { 
    VALUE, 
    OPERATOR, 
    BRACKET,
    FUNCTION,
}

var type: TokenType
var value: String

@warning_ignore("shadowed_variable")
func _init(type: TokenType, value: String):
    self.type = type
    self.value = value
