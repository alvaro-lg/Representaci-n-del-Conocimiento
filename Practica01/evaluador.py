import re
 import collections
 from functools import wraps, partial

 def debug_method(func= None, prefix = ''):
     if func is None:
         return partial(debug, prefix = prefix)
     else:
         msg = prefix + func.__name__
         @wraps(func)
         def wrapper(*args, **kwargs):
             print(msg)
             return func(*args,**kwargs)
         return wrapper

 def debug_class(cls):
     for key, val in vars(cls).items():
         if callable(val):
             setattr(cls, key, debug_method(val))
         return cls

 print("Evaluado el codigo")

 separacion = 60

 CONST     = r'(?P<CONST>[a-z][A-Z]*)'
 NUM     = r'(?P<NUM>\d+)'
 PLUS    = r'(?P<PLUS>\+)'
 MINUS   = r'(?P<MINUS>-)'
 OR    = r'(?P<OR>∨)'
 AND   = r'(?P<AND>∧)'
 NOT   = r'(?P<NOT>¬)'
 TIMES   = r'(?P<TIMES>\*)'
 DIVIDE  = r'(?P<DIVIDE>/)'
 LPAREN  = r'(?P<LPAREN>\()'
 RPAREN  = r'(?P<RPAREN>\))'
 WS      = r'(?P<WS>\s+)'
 VERDADERO  = r'(?P<VERDADERO>TRUE)'
 FALSO  = r'(?P<FALSO>FALSE)'

 master_pattern = re.compile('|'.join((CONST,NUM, PLUS, MINUS, OR, AND, NOT,
                                       TIMES, DIVIDE, LPAREN, RPAREN, WS,
                                       VERDADERO, FALSO)))
 Token = collections.namedtuple('Token', ['type', 'value'])


 def lista_tokens(pattern, text):
     scanner = pattern.scanner(text)
     for m in iter(scanner.match, None):
         token = Token(m.lastgroup, m.group())

         if token.type != 'WS':
             yield token

 print(list(lista_tokens(master_pattern,'x ∨ y v z' )))


 class SentenciaBooleana:
     '''
     Pequeña implementación de un parser de sentenciaesiones booleanas.
     Implementation of a recursive descent parser.
     Aquí la asignacion es un diccionario con variables.
     '''

     def parse(self, text, asig):
         self.tokens = lista_tokens(master_pattern, text)
         self.current_token = None
         self.next_token = None
         self._avanza()
         self.asig = asig
         return self.sentencia()


     def _avanza(self):
         self.current_token, self.next_token = self.next_token, next(self.tokens, None)

     def _acepta(self, token_type):
         # if there is next token and token type matches
         if self.next_token and self.next_token.type == token_type:
             self._avanza()
             return True
         else:
             return False

     def _espera(self, token_type):
         if not self._acepta(token_type):
             raise SyntaxError('Expected ' + token_type)

     def sentencia(self):
         '''
         sentencia : conjuncion | conjuncion ∨ sentencia
         '''
         sentencia_value = self.conjuncion()
         if self._acepta('OR'):
             sentencia_value = sentencia_value | self.sentencia()
         return sentencia_value

     def conjuncion(self):
         '''
         conjuncion : clausula | clausula ∧ conjuncion
         '''

         conj_value = self.clausula()
         if self._acepta('AND'):
             conj_value = conj_value & self.conjuncion()
         return conj_value

     def clausula(self):
         '''
         clausula : CONST | (sentencia)

         '''
         # Si aparece un parentesis
         if self._acepta('LPAREN'):
             sentencia_value = self.sentencia()
             self._espera('RPAREN')
             return sentencia_value
         elif self._acepta('CONST'):
             return self.asig[self.current_token.value]

 def satisfacible(sentencia, text):

     asig_aux = sentencia.asig.copy()

     for n in range(0, (len(asig_aux.keys()) ** 2)):
         m = n
         for v in asig_aux.keys():
             asig_aux[v] = bool(m % 2)
             m = m >> 1
             resul = prueba_asignacion(asig_aux, text)
             if resul:
                 return asig_aux
     return False

 def prueba_asignacion(asignacion, text):
     tmp = SentenciaBooleana()
     return tmp.parse(text, asignacion)

 e = SentenciaBooleana()
 text='x ∨ (y ∧ z ∧ x)'
 print(e.parse(text,{'x':False, 'y':False, 'z':True}))
 print(satisfacible(e, text))

 '''
 Explicacion del uso de la operacion % 25:

 Se utiliza para castear un número entero a una letra del abecedario. Se hace char chr(97 + (self.pos%25))
 donde 0x97 es el codigo ASCII de la primera letra del abecedario y 25 es el numero de letras que tienen el 
 abecedario ASCII. Por lo que se calcula para un numero la letra del abecedario que le corresponde
 '''

 class GeneracionSentencias:

     def __init__(self, pos):
         self.pos = pos

     def sentencia(self):
         '''
         Sentencia retorna el string con la fórmula
         '''
         if self.pos % 2 == 0:
             self.pos = self.pos >> 1
             return self.conjuncion()
         else:
             self.pos = self.pos >> 1
             resultado = self.conjuncion()
             return  resultado+ "∨" + self.sentencia()


     def conjuncion(self):
         '''
         Sentencia retorna el string con la fórmula
         '''
         if self.pos%2 == 0:
             self.pos = self.pos >> 1
             return self.clausula()
         else:
             self.pos = self.pos >> 1
             resultado = self.clausula()
             return  resultado + "∧" + self.conjuncion()


     def clausula(self):
         '''
         Sentencia retorna el string con la fórmula
         '''
         if self.pos%2 == 0:
             self.pos = self.pos >> 1
             resultado, self.pos = chr(97 + (self.pos%25)), self.pos//25
             return resultado
         else:
             self.pos = self.pos >> 1
             return '(' + self.sentencia() + ')'