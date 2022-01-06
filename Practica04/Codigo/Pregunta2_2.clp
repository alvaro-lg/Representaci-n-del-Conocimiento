(deffacts initial
  (automata q0 "1" "1" "0" "0" "$")
  (transicion q1 "0" q2)
  (transicion q0 "0" q1)
  (transicion q0 "1" q0)
  (transicion q0 "0" q0)
)

(defrule acepta_palabra
  (declare (salience 0))
  (automata q2 "$")
 =>
  (printout t "Palabra Aceptada" crlf)
)

(defrule rechaza_palabra
  (declare (salience 0))
  (not (automata q2 "$"))
 =>
  (printout t "Palabra Rechazada" crlf)
)

(defrule error
  (declare (salience 1))
  ?automata <- (automata ?qaux $siguiente $?otros)
 =>
  (retract ?automata)
)


(defrule transicciona
  (declare (salience 2))
  ?transicion <- (transicion ?qstart ?char ?qend)
  ?automata <- (automata ?qstart ?char $?otros)
 =>
  (retract ?automata)
  (assert (automata ?qend ?otros))
  (printout t ?qstart " -> " ?char " -> " ?qend crlf)
)