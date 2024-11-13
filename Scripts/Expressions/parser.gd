class_name Parser

# Modified shunting yard algorithm
static func parse(tokens : Array[Token]) -> Array[ExpressionNode]:
    var output = []
    var operator_stack = []

    for token in tokens:
        if token.type == Token.TokenType.VALUE:
            output.append(ExpressionNode.new(token))
        elif token.type == Token.TokenType.FUNCTION:
            operator_stack.append(ExpressionNode.new(token))
        elif token.type == Token.TokenType.OPERATOR:
            while (
                operator_stack.size() > 0 and 
                operator_stack[-1].type != Token.TokenType.BRACKET_CLOSE and
                (
                    operator_stack[-1].precedence > token.precedence or 
                    #  or (o1 and o2 have the same precedence and o1 is left-associative) 
                    (operator_stack[-1].precedence == token.precedence and operator_stack[-1].value !=  '^')
                )
            ):
                output.append(operator_stack.pop_back())
            operator_stack.append(ExpressionNode.new(token))
        elif token.type == Token.TokenType.BRACKET_OPEN:
            operator_stack.append(ExpressionNode.new(token))
        elif token.type == Token.TokenType.BRACKET_CLOSE:
            while operator_stack.size() > 0 and operator_stack[-1].type != Token.TokenType.BRACKET_OPEN:
                output.append(operator_stack.pop_back())

            if operator_stack.size() == 0:
                return []
            
            output.append(operator_stack.pop_back())


            operator_stack.pop_back()
            if operator_stack.size() > 0 and operator_stack[-1].type == Token.TokenType.FUNCTION:
                output.append(operator_stack.pop_back())
    
    while operator_stack.size() > 0:
        if operator_stack[-1].type == Token.TokenType.BRACKET_OPEN:
            return []
        output.append(operator_stack.pop_back())

    return output