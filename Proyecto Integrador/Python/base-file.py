class DFA:
    def __init__(self, initial, accept, function):
        self.initial = initial
        self.accept = accept
        self.func = function


def arithmetic_lexer(expression):
    dfa = DFA('start', ['int', 'float', 'exp', 'var', 'spa'], delta_arithmetic)
    return evaluate_dfa(dfa, expression)


def evaluate_dfa(dfa, string):
    chars = list(string)
    state = dfa.initial
    tokens = []
    for char in chars:
        # Found will be false unless we have completely identified a token
        state, found = dfa.func(state, char)
        if found:
            tokens.append(found)
    # Check if the last state is an acceptable one
    if state in dfa.accept:
        # Add the last pending state to the list
        tokens.append(state)
        return tokens
    return "INVALID EXPRESSION"


def is_operator(char):
    return char in list("+-*/=^")


def delta_arithmetic(state, char):
    if state == 'start':
        if char.isnumeric():
            new_state, found = ['int', False]
        elif char == '+' or char == '-':
            new_state, found = ['sign', False]
        elif char.isalpha() or char == '_':
            new_state, found = ['var', False]
        else:
            new_state, found = ['inv', False]
    elif state == 'sign':
        if char.isnumeric():
            new_state, found = ['int', False]
        else:
            new_state, found = ['inv', False]
    elif state == 'int':
        if char.isnumeric():
            new_state, found = ['int', False]
        elif char == '.':
            new_state, found = ['dot', False]
        elif char == 'e' or char == 'E':
            new_state, found = ['e', False]
        elif is_operator(char):
            new_state, found = ['op', 'int']
        elif char.isspace():
            new_state, found = ['space', 'int']
        else:
            new_state, found = ['inv', False]
    elif state == 'dot':
        if char.isnumeric():
            new_state, found = ['float', False]
        else:
            new_state, found = ['inv', False]
    elif state == 'float':
        if char.isnumeric():
            new_state, found = ['float', False]
        elif char == 'e' or char == 'E':
            new_state, found = ['e', False]
        elif is_operator(char):
            new_state, found = ['op', 'float']
        elif char.isspace():
            new_state, found = ['space', 'float']
        else:
            new_state, found = ['inv', False]
    elif state == 'e':
        if char.isnumeric():
            new_state, found = ['exp', False]
        elif char == '+' or char == '-':
            new_state, found = ['exp_sign', False]
        else:
            new_state, found = ['inv', False]
    elif state == 'exp_sign':
        if char.isnumeric():
            new_state, found = ['exp', False]
        else:
            new_state, found = ['inv', False]
    elif state == 'exp':
        if char.isnumeric():
            new_state, found = ['exp', False]
        elif is_operator(char):
            new_state, found = ['op', 'exp']
        elif char.isspace():
            new_state, found = ['space', 'exp']
        else:
            new_state, found = ['inv', False]
    elif state == 'var':
        if char.isalpha() or char == '_' or char.isnumeric():
            new_state, found = ['var', False]
        elif is_operator(char):
            new_state, found = ['op', 'var']
        elif char.isspace():
            new_state, found = ['space', 'var']
        else:
            new_state, found = ['inv', False]
    elif state == 'op':
        if char.isnumeric():
            new_state, found = ['int', 'op']
        elif char == '+' or char == '-':
            new_state, found = ['sign', 'op']
        elif char.isalpha() or char == '_':
            new_state, found = ['var', 'op']
        elif char.isspace():
            new_state, found = ['op_spa', 'op']
        else:
            new_state, found = ['inv', False]
    elif state == 'space':
        if char.isspace():
            new_state, found = ['space', False]
        elif is_operator(char):
            new_state, found = ['op', False]
        else:
            new_state, found = ['inv', False]
    elif state == 'op_spa':
        if char.isnumeric():
            new_state, found = ['int', False]
        elif char == '+' or char == '-':
            new_state, found = ['sign', False]
        elif char.isalpha() or char == '_':
            new_state, found = ['var', False]
        elif char.isspace():
            new_state, found = ['op_spa', False]
        else:
            new_state, found = ['inv', False]
    else:
        new_state, found = ['inv', False]
    return new_state, found


if __name__ == '__main__':
    import doctest
    doctest.testmod()
