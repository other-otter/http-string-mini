# http-string-mini

```common-lisp
#|how to use the code

;(read-input-string the-http-string)
;input-type: string ;output-type: list 
;   example: 
(read-input-string 
  (format nil 
"GET /common-lisp/cl-async?lib=libuv&&package=cffi http/1.1~c~cHost: 127.0.0.1~c~c~c~csay-hi-in-http"
#\return #\newline #\return #\newline #\return #\newline))
;(getf http-list :http-field-list)

;(make-output-string the-http-list)
;input-type: list ;output-type: string
;    example: 
(make-output-string 
    (list   :http-hair-code 200
            :http-face-list (list "X-note: http-response" "Content-Type: text/plain")
            :http-body-utf8 "hi ~~"))

|#
```
