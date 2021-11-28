(deffacts initial
  (estado q0)
  (caracter "1")
  (entrada "0" "0" "0" "lambda")
)

(defrule acepta_palabra
  ?estado_actual <- (estado q2)
  ?cinta <- (entrada)
 =>
  (printout t "Palabra Aceptada" crlf)
)

(defrule transicion_q0_0
  ?estado_actual <- (estado q0)
  ?simbolo_actual <- (caracter "0")
  ?cinta <- (entrada ?siguiente $?otros)
 =>
  (retract ?estado_actual)
  (retract ?simbolo_actual)
  (retract ?cinta)
  (assert (caracter ?siguiente))
  (assert (estado q0))
  (assert (estado q1))
  (assert (entrada $?otros))
  (printout t "q0 -> 0 -> q0" crlf)
  (printout t "q0 -> 0 -> q1" crlf)
)

(defrule transicion_q0_1
  ?estado_actual <- (estado q0)
  ?simbolo_actual <- (caracter "1")
  ?cinta <- (entrada ?siguiente $?otros)
 =>
  (retract ?estado_actual)
  (retract ?simbolo_actual)
  (retract ?cinta)
  (assert (caracter ?siguiente))
  (assert (estado q0))
  (assert (entrada $?otros))
  (printout t "q0 -> 1 -> q0" crlf)
)

(defrule transicion_q1_0
  ?estado_actual <- (estado q1)
  ?simbolo_actual <- (caracter "0")
  ?cinta <- (entrada ?siguiente $?otros)
 =>
  (retract ?estado_actual)
  (retract ?simbolo_actual)
  (retract ?cinta)
  (assert (caracter ?siguiente))
  (assert (estado q2))
  (assert (entrada $?otros))
  (printout t "q1 -> 0 -> q2" crlf)
)