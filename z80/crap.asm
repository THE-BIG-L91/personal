	DEVICE ZXSPECTRUM48
	org $8000

print_both:
	push af
	ld a, (cnst1)
	add a, $30
	rst $10

	ld a, (cnst2)
	add a, $30
	rst $10
	pop af


sub_test:
	push af
	push bc

	ld a, (cnst2) ; load B into a
	ld b, a
	ld a, (cnst1) ; load A into a

	sub b ; A = A - B
	jp m, negative	; if b > a
	jr z, negative
	ld (cnst1), a ; a = a - b, since a>b
	jp end
negative:
	neg	; b > a, so we flip a
	ld (cnst2), a   ; b = b - a 
end:
	pop bc
	pop af
	ret

start:
	call sub_test
	call print_both
	halt


cnst1: db 3
cnst2: db 2

	SAVESNA "file.sna", start