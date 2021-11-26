(deffacts initial
  (estado q0)
  (caracter "1")
  (entrada "0" "0" "0" "lambda")
  (transicion q0 "1" q0)
  (transicion q0 "0" q0)
  (transicion q0 "0" q1)
  (transicion q1 "0" q2)
)

(defrule acepta_palabra
  ?estado_actual <- (estado q2)
  ?cinta <- (entrada ?siguiente)
 =>
  (printout t "Palabra Aceptada" crlf)
)

(defrule procesa
  ?transicion <- (transicion ?qstart ?char ?qend)
  ?estado_actual <- (estado ?qstart)
  ?simbolo_actual <- (caracter ?char)
  ?cinta <- (entrada ?siguiente $?otros)
 =>
  (retract ?estado_actual)
  (retract ?cinta)
  (retract ?simbolo_actual)
  (assert (entrada $?otros))
  (assert (estado ?qend))
  (assert (caracter ?siguiente))
  (printout t ?qstart " -> " ?char " -> " ?qend crlf)
)