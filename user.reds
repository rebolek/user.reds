Red/System[
	Title: "user.reds" 
	Author: "Boleslav Brezovsky" 
	Date: 12-7-2012
]

; --- definitions

logic!:	1
integer!:	2
byte!:	3
float32!:	4
float!:	5
c-string!:	6
;byte-ptr!:	7
;int-ptr!:	8
function!:	9
struct!:	1000

; --- arrays

; DO NOT USE

_array: func [	; create array
	length 	[integer!]
	type		[integer!]
	return: 	[struct! [
		length	[integer!]
		type		[integer!]
		cell-size	[integer!]
		data		[byte-ptr!]
	]]
	/local cell-size byte-length array* array
][
	cell-size: switch type [
		2	[4]
		3	[1]
		4	[4]
		5	[8]
	]
	byte-length: length * cell-size
	array*: allocate byte-length
	array: declare struct! [
		length	[integer!]
		type		[integer!]
		cell-size	[integer!]
		data		[byte-ptr!]
	]
	array/length: byte-length
	array/type: type
	array/cell-size: cell-size
	array/data: array*
	array
]

_poke: func [
	array		[struct! [
		length	[integer!]
		type		[integer!]
		cell-size	[integer!]
		data		[byte-ptr!]
	]]
	index		[integer!]
	value		[byte-ptr!]
][
	print ["type:" array/type]
	switch array/type [
		2	[
			print ["integer!" value/value lf]
		]
		5	[
			print ["float!" value/value lf]
		]
	]
]

_pick: func [
	array		[struct! [
		length	[integer!]
		type		[integer!]
		cell-size	[integer!]
		data		[byte-ptr!]	
	]]
	index		[integer!]	; 1-based offset
	return:	[integer!]
][
	p: as pointer! [integer!] array/data + (index - 1 * 4) ; 4 bytes = 32 bits
	p/value
]

; --- math 

float-to-int: func [
	number 	[float!]
	return:	[integer!]
	/local magic-number data ptr val1 val2 val3 val4
][
	magic-number: 68719476736.0 * 1.5
	data: declare struct! [
		float [float!]
	]
	data/float: number + magic-number
	ptr: as byte-ptr! data
	ptr: ptr + 2
	val1: as integer! ptr/value
	ptr: ptr + 1
	val2:  as integer! ptr/value
	ptr: ptr + 1
	val3:  as integer! ptr/value
	ptr: ptr + 1
	val4:  as integer! ptr/value
	val1 + (256 * val2) + (65536 * val3) + (16777216 * val4)
	
]

; --- strings

equal?: func [
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