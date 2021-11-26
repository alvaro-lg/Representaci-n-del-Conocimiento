(deffacts initial
  (caracter "0")
  (entrada "0" "1" "1" "lambda")
  (transicion q0 "1" q0)
  (transicion q0 "0" q1)
  (transicion q0 "0" q1)
  (transicion q1 "0" q2)
)

(defrule transicciona
  ?transicion <- (transicion ?qstart ?siguiente ?qend)
  ?cinta <- (entrada ?siguiente $?otros)
 =>
  (retract ?transicion)
  (assert (transicion ?qstart ?siguiente ?qend))
  (printout t ?qstart " -> " ?siguiente " -> " qend crlf)))
)