; 'text2win' lisp macro [ver 1.5 29/08/2002]
; decode text in old acad drawing (dos->win)
; (c)2002, Smolin Roman.	E-mail: sm0l@nm.ru, sm0l@chat.ru
(defun t2w_findchar (string ch / i pos) ; find char in string, return pos
	(setq i 1 pos nil)
	(while (and (<= i (strlen string)) (null pos))
		(if (equal (substr string i 1) (substr ch 1 1))
			(setq pos i))
		(setq i (1+ i))
	)
	(setq pos pos)
)

(defun t2w_decode (string / i new pos) ; return decode string dos->win
	(setq i 1 new "")
	(while (<= i (strlen string))
		(setq pos (t2w_findchar dos (substr string i 1)))
		(if (null pos)
			(setq new (strcat new (substr string i 1)))
			(setq new (strcat new (substr win pos 1))))
		(setq i (1+ i))
	)
	(setq new new)
)

(defun t2w_validstyle (style / i result) ; test style for dos symbols, return T or NIL
	(setq i 1 result T)
	(while (<= i (strlen style))
		(if (t2w_findchar dos (substr style i 1))
			(setq result NIL)) ; dos char found
	 	(setq i (1+ i))
	)
 	(initget 1 "Yes No")
	(if (not result) ; add to invalid styles list?
		(if (equal "Yes" (getkword (strcat "Found unusual style [" (cdr (assoc 7 text))
								"]. Change it to STANDARD?(Y/N)")))
			(setq invalid_styles (cons (cdr (assoc 7 text)) invalid_styles)) ; yes, bad
		 	(setq result T))						 ; no, right
	)
		
	(setq result result)
)


(defun C:text2win (/ text i) ; AutoCAD command
	(setq win "ÀÁÂÃÄÅ¨ÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäå¸æçèéêëìíîïðñòóôõö÷øùúûüýþÿ")
	(setq dos "€‚ƒ„…ð†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ ¡¢£¤¥ñ¦§¨©ª«¬­®¯àáâãäåæçèéêëìíîï")
	(setq i 0 invalid_styles nil)

	(initget 1 "Yes No")
	(if (equal "Yes" (getkword "Convert all text entries?(Y/N)"))
		(setq ss (ssget "X" (list (cons 0 "TEXT"))))
		(setq ss (ssget))) ; manual selection

	(prompt "Checking styles...\n")
	(while (< i (sslength ss)) ; changing style
		(setq text (entget (ssname ss i)))
		(if (equal (cdr (assoc 0 text)) "TEXT") ; this is a text?

			(if (member (cdr (assoc 7 text)) invalid_styles) ; style in bad list?
				(entmod (subst (cons 7 "STANDARD") (assoc 7 text) text))

				(if (not (t2w_validstyle (cdr (assoc 7 text)))) ; else - test style (if bad - add to list)
					(entmod (subst (cons 7 "STANDARD") (assoc 7 text) text)))
			)

		)		 		
		(setq i (1+ i))
	)

	(setq i 0)
	(prompt "Changing text...\n")
	(while (< i (sslength ss)) ; changing text
		(setq text (entget (ssname ss i)))
		(if (equal (cdr (assoc 0 text)) "TEXT") ; this is a text?
				(entmod (subst (cons 1 (t2w_decode (cdr (assoc 1 text)))) (assoc 1 text) text)))
		(setq i (1+ i))
	)

	(setq win nil dos nil invalid_styles nil)
	(princ (strcat "All done. Processed " (itoa (sslength ss)) " text entries."))
	(princ)
)