(in-package :cl-user)

;;read-input-string
(defun split-string (string &key (delimiter (string #\space)) (max -1))
    (let ((pos (search delimiter string)))
        (if (or (= max 0) (eq nil pos))
            (list string)
            (cons
                (subseq string 0 pos)
                (split-string (subseq string (+ pos (length delimiter)))
                    :delimiter delimiter
                    :max (if (= max -1) -1 (- max 1)))))))

(defun read-input-string (the-string)
	(if (stringp the-string) 
		(let* (	(http-list (split-string the-string :delimiter #(#\return #\newline #\return #\newline) :max 1))
				(http-head (car  http-list))
				(http-body (cadr http-list))
				(head-list (split-string http-head :delimiter #(#\return #\newline) :max 20))
				(http-hair (car head-list))
				(http-face (cdr head-list))
				(face-list (loop for string in http-face collect (split-string string :max 1)))
				(hair-list (split-string http-hair :delimiter #(#\space) :max 3))
				(http-meth (car hair-list))
				(http-url  (cadr hair-list))
				(url-list  (split-string http-url :delimiter #(#\?) :max 1))
				(url-path  (car  url-list))
				(url-vars  (cadr url-list))
				(var-list  (split-string url-vars :delimiter #(#\&) :max 20))
				(the-vars  (remove-if (lambda (var) (equal var "")) var-list)) 
				(url-args  (loop for string in the-vars collect (split-string string :delimiter #(#\=) :max 1))))
			(list 	:http-method-string http-meth 
					:http-path-string   url-path
					:http-var-list      url-args
					:http-field-list    face-list
					:http-body-string   http-body))
		501))
        
;;make-output-string
(setf err-map (make-hash-table))

(defun print-http-field (the-list)
    (if the-list
        (with-output-to-string (*standard-output*)
            (mapcar (lambda (the-field) 
                (format t "~A~c~c" the-field #\return #\newline)) the-list))
        (format nil "X-Power-by: common-lisp~c~c" #\return #\newline)))

(defun make-http-string (&key   (http-hair-code 404) 
                                (http-face-list nil) 
                                (http-body-utf8 "something-wrong"))
    (format nil 
"HTTP/1.1 ~A~c~cContent-length: ~A~c~c~A~c~c~A" 
http-hair-code                      #\return #\newline 
(length http-body-utf8)             #\return #\newline 
(print-http-field http-face-list)   #\return #\newline 
http-body-utf8))

(defun add-err (the-number the-string)
    (setf (gethash the-number err-map) 
        (make-http-string   :http-hair-code the-number 
                            :http-body-utf8 the-string)))

(add-err 404 "page-not-found")

(defun make-output-string (the-list)
    (let ((http-status-number (getf the-list :http-hair-code)))
        (if http-status-number
            (if (<= 100 http-status-number 300)
                (apply #'make-http-string the-list)
                (let ((error-string (gethash http-status-number err-map)))
                    (if error-string
                        error-string
                        (gethash 555 err-map))))
            (gethash 501 err-map))))
