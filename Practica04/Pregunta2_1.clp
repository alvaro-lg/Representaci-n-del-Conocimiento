(deffacts initial
  (automata q0 "0" "0" "1" "1" "$")
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

(defrule transicion_q0_1
  (declare (salience 2))
  ?automata <- (automata q0 "1" $?otros)
 =>
  (retract ?automata)
  (assert (automata q0 $?otros))
  (printout t "q0 -> 1 -> q0" crlf)
)

(defrule transicion_q0_0
  (declare (salience 2))
  ?automata <- (automata q0 "0" $?otros)
 =>
  (retract ?automata)
  (assert (automata q0 $?otros))
  (assert (automata q1 $?otros))
  (printout t "q0 -> 0 -> q0" crlf)
  (printout t "q0 -> 0 -> q1" crlf)
)

(defrule transicion_q1_0
  (declare (salience 3))
  ?automata <- (automata q1 "0" $?otros)
 =>
  (retract ?automata)
  (assert (automata q2 $?otros))
  (printout t "q1 -> 0 -> q2" crlf)
)