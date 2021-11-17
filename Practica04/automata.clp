(defrule transicion_q0_0
  ?estado_actual <-(estado q0)
  ?simbolo_actual <-(caracter "0")
  ?cinta <-(entrada  ?siguiente $?otros)
 =>
  (retract ?estado_actual)
  (retract ?simbolo_actual)
  (retract ?cinta)
  (assert (caracter ?siguiente))
  (assert (estado q0))
  (assert (cinta $?otros))
  (printout t ?siguiente crlf)
)


; (assert (estado q0))
; (assert (caracter "0"))
; (assert (entrada "0" "c"))