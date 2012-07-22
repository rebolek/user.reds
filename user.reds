Red/System[
	Title: "user.reds" 
	Author: "Boleslav Brezovsky" 
	Date: 12-7-2012
]

; --- definitions

pi: 3.14159265358979
type-int16!: 10001
; --- arrays

array!: alias struct! [
	length	[integer!]
	type		[integer!]
	cell-size	[integer!]
	data		[byte-ptr!]
]

array: func [	; create array
	length 	[integer!]
	type		[integer!]
	return: 	[array!]
	/local cell-size byte-length data* array t-array
][
	cell-size: switch type [
		2		[4]
		3		[1]
		4		[4]
		5		[8]
		10001	[2]
	]
	byte-length: length * cell-size
	data*: allocate byte-length
	t-array: declare array!
	array: as array! allocate size? t-array
	array/length: byte-length
	array/type: type
	array/cell-size: cell-size
	array/data: data*
	array
]

poke: func [
	array		[array!]
	index		[integer!]
	value		[byte-ptr!]	; I use pointer here so I can pass both integer and float!
	/local pi pf vi vf
][
	print ["type:" array/type lf]
	switch array/type [
		2	[
			; NOTE: only way to pass pointer to integer! *right now*
			; is to enclose it in struct!
			; so we get our value from that struct!
			; TODO: rewrite when we can use pointer! to integer!
			vi: as struct! [value [integer!]] value
			pi: as pointer! [integer!] array/data + (index - 1 << 2)
			pi/value: vi/value
		]
		5	[
			; NOTE: only way to pass pointer to integer! *right now*
			; is to enclose it in struct!
			; so we get our value from that struct!
			; TODO: rewrite when we can use pointer! to integer!
			vf: as struct! [value [float!]] value
			pf: as pointer! [float!] array/data + (index - 1 << 3)
			pf/value: vf/value
		]
		10001	[
		
		]
	]
]

pokei: func [
	array		[array!]
	index		[integer!]
	value		[integer!]
	/local p
][
	p: as pointer! [integer!] array/data + (index - 1 << 2)
	p/value: value
]

pokeh: func [
	array		[array!]
	index		[integer!]
	value		[integer!]
	/local p
][
	v: declare struct! [value [integer!]]
	v/value: value
	v0: as byte-ptr! v
	p: as pointer! [byte!] array/data + (index - 1 << 1)
	p/1: v0/1
	p/2: v0/2
]

pokef: func [
	array		[array!]
	index		[integer!]
	value		[float!]
	/local p
][
	p: as pointer! [float!] array/data + (index - 1 << 3)
	p/value: value
]

picki: func [
	array		[array!]
	index		[integer!]	; 1-based offset
	return:	[integer!]
	/local p v
][
	p: as int-ptr! array/data + (index - 1 * array/cell-size)
	p/value
]

pickh: func [
	array		[array!]
	index		[integer!]	; 1-based offset
	return:	[integer!]
	/local p v
][
	p: as int-ptr! array/data + (index - 1 * array/cell-size)
	256 * p/2 + p/1
]

pickf: func [
	array		[array!]
	index		[integer!]	; 1-based offset
	return:	[float!]
	/local p v
][
	p: as pointer! [float!] array/data + (index - 1 * array/cell-size)
	p/value
]


; --- math 

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
	/local magic-number data ptr val1 val2 val3 val4
][
	magic-number: 68719476736.0 * 1.5
	data: declare struct! [
		float [float!]
	]
	data/float: number + magic-number
	ptr: as byte-ptr! data
	as integer! ptr/3
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

; --- test