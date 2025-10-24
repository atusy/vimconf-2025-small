; (comment) @comment
; (
;   (string) ; node type
;   @string  ; capture name (highlight group)
; )

; (
;   ; Capture string_content inside string
;   string (string_content) @string.special.url
;   ; Keep capture iff it matches URL pattern
;;   (#match? @string.special.url "^https?://\\S+$")
; )
