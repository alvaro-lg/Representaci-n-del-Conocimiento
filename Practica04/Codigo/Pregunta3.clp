
(deffacts initial
  (estado q0)
  (transicion q0 "0" q1)
  (transicion q0 "1" q0)
  (transicion q1 "0" q2)
  (estado_final q2)
)

(defrule palabra_aceptada
  (not (transicion ?qini ?char ?qfin))
  ?estado <- (estado ?q $?chars)
  ?estado_final <- (estado_final ?q)
 =>
  (printout t $?chars crlf)
)

(defrule recorre
  ?transicion <- (transicion ?qini ?char ?qfin)
  ?estado <- (estado ?qini $?caracteres)
 =>
  (retract ?estado)
  (retract ?transicion)
  (assert (estado ?qfin $?caracteres ?char))
)



