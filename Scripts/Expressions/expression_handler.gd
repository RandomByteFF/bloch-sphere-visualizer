class_name ExpressionHandler extends Object
## This class could evaluate expressions so that users can provide their own operations on the complex numbers
## 
## But this seems to be more complicated than you would think:
## cause complex numbers have 3 representations and the trigonometric contains trigonometric functions
## so basically this class should take an expression, create an abstract syntax tree, evaluate it with complex numbers
## which leads to several other problems