Red/System[
	Title: "user.reds" 
	Author: "Boleslav Brezovsky" 
	Date: 5-9-2013
]

; --- definitions

pi: 3.14159265358979
type-int16!: 10001
crlf: "^M^/"

; --- math 

abs: func[
	x [integer!]
	return: [integer!]
][
	(x xor (x >> 31)) - (x >> 31)
]

fabs: func [
	x			[float!]
	return:	[float!]
][
	x: either x < 0.0 [0.0 - x][x]
	x
]

float-to-int: func [
	number 	[float!]
	return:	[integer!]
	/local magic-number data ptr val1 va2 val3 val4
][
	magic-number: 68719476736.0 * 1.5
	data: declare struct! [
		float [float!]
	]
	data/float: number + magic-number
	; TODO: simplify this!
	ptr: as byte-ptr! data
	val1: as integer! ptr/3
	val2: as integer! ptr/4
	val3: as integer! ptr/5
	val4: as integer! ptr/6
	(16777216 * val4) + (65536 * val3) + (256 * val2) + val1
]

int-to-float: func [
	n [integer!]
	return: [float!]
	/local sign shifts less?
][
	sign: 0
	shifts: 0
	less?: true

;    1. If N is negative, negate it in two's complement. Set the high bit (2^31) of the result.
	if n < 0 [
		n: not n
		sign: 1 << 31
	]

;    2. If N < 2^23, left shift it (multiply by 2) until it is greater or equal to.
	while [n < 00800000h] [
		less?: true
		shifts: shifts + 1
		n: n << 1
	]

;    3. If N >= 2^24, right shift it (unsigned divide by 2) until it is less.
	while [n >= 01000000h] [
		less?: false
		shifts: shifts + 1
		n: n >> 1
	]

;    4. Bitwise AND with ~2^23 (one's complement).
	n: n and not 00800000h

;    5. If it was less, subtract the number of left shifts from 150 (127+23).
	if all [less? 0 < shifts][
		shifts: 150 - shifts
	]

;    6. If it was more, add the number of right shifts to 150.
	if all [not less? 0 < shifts][
		shifts: 150 + shifts
	]
;    7. This new number is the exponent. Left shift it by 23 and add it to the number from step 3.
	shifts: shifts << 23
;	n + shifts
	
;	hack to convert float32! to float64!
	0.0 + as float32! sign or n + shifts
]


**: func [
	[infix]
	number	[integer!]
	power	[integer!]
	return:	[integer!]
	/local i result
][
	i: 0
	result: 1
	while [i < power][
		result: result * number
		i: i + 1
	]
	result
]

negate: function [
	value	[integer!]
	return:	[integer!]
][
	1 + not value
]

; =================================
; --- strings

next: func [
	string 	[c-string!]
	return:	[c-string!]
][
	string + 1
]

back: func [
	string 	[c-string!]
	return:	[c-string!]
][
	string - 1
]

equal-string?: func [
	; compare two strings
	string1	[c-string!]
	string2	[c-string!]
	return:	[logic!]
	/local i l s1 s2
][
	l: length? string1
	either l = (length? string2) [
		i: 0
		while [i < l][
			s1: string1 + i
			s2: string2 + i
			unless s1/1 = s2/1 [return false]
			i: i + 1
		]
		true
	][
		false
	]
]

end?: func [
	"Returns TRUE when first byte of the string is null-byte"
	string 		[c-string!]
	return:		[logic!]
][
	string/1 = null-byte
]

match-string: func [
	"Check if the beginning of the string matches given substring"
	string 		[c-string!]
	substring	[c-string!]
	return:		[logic!]
	/local
	matched?	[logic!]
	i 			[integer!]
][
	matched?: true
	; main loop 
	until [

	; end condition
		substring: next substring
		end? substring
	]
	true
]

find-string: func [
	"Find substring in string"
	string	[c-string!]
	match	[c-string!]
	return:	[c-string!]	; return index 
	/local substring match?
][
	substring: string
	match?: false
	until [
		if match/1 = string/1 [
			match?: true
			substring: string
			until [
				if match/1 <> substring/1 [match?: false]
				match: match + 1
				substring: substring + 1
				null-byte = match/1
			]
			if match? [
				return string
			]
		]
		string: string + 1
		string/1 = null-byte
	]
	return ""
]

reverse-string: func [
	data	[c-string!]
	return:	[c-string!]
	/local len out i j
][
	len: length? data
	out: as c-string! allocate len
	i: 1
	j: len
	until [
		out/i: data/j
		j: j - 1
		i: i + 1
		i > len
	]
	out
]

change-string: function [
	"Change target string with value at index"
	target	[c-string!]
	value 	[c-string!]
	return:	[c-string!]
	/local
		start 	[c-string!]
][
	; TODO: check limits
	start: target
	until [
		target/1: value/1
		value: value + 1
		target: target + 1
		value/1 = null-byte
	]
	start
]

change-string-at: function [
	"Change target string with value at index"
	target	[c-string!]
	value 	[c-string!]
	index 	[integer!]
	return:	[c-string!]
	/local
		start 	[c-string!]
][
	; TODO: check limits
	start: target
	target: target + index - 1
	until [
		target/1: value/1
		value: value + 1
		target: target + 1
		value/1 = null-byte
	]
	start
]

count-char: function [
	"Count character occurrence in string"
	string	[c-string!]
	char 	[byte!]
	return:	[integer!]
	/local count index length
][
	count: 0
	until [
		if string/1 = char [count: count + 1]
		string: string + 1
		string/1 = null-byte
	]
	count
]

form-int: func [
	"Return integer! as c-string!"
	number	[integer!]
	return:	[c-string!]
	/local out i 
][
	; TODO: negative numbers
	remainder: number
	out: as c-string! allocate 10 ; 32bit number
	i: 1
	until [
		out/i: as byte! 48 + as integer! number // 10
		number: number / 10
		i: i + 1
		number = 0
	]
	out/i: #"^(00)"	; force end of string
	reverse-string out
]

load-int: func [
	"Load integer value from string"
	value	[c-string!]
	return:	[integer!]
	/local
	out		[integer!]
	negate?	[logic!]
	index	[integer!]
	length 	[integer!]
	mult 	[integer!]
][
	out: 0
	negate?: false
	; check for minus sign
	if #"-" = value/1 [
		negate?: true
		value: value + 1
	] 
	; main loop
	length: length? value
	index: length
	mult: 1
	until [
		out: out + ((as integer! value/index) - 48 * mult)
		mult: mult * 10
		index: index - 1
		index = 0
	]
	; negate when necessary
	if negate? [out: negate out]
	out
]