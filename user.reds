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
		2	[4]
		3	[1]
		4	[4]
		5	[8]
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
	value		[byte-ptr!]
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
			pi: as pointer! [integer!] array/data + (index - 1 * 4)
			pi/value: vi/value
		]
		5	[
			; NOTE: only way to pass pointer to integer! *right now*
			; is to enclose it in struct!
			; so we get our value from that struct!
			; TODO: rewrite when we can use pointer! to integer!
			vf: as struct! [value [float!]] value
			pf: as pointer! [float!] array/data + (index - 1 * 8)
			pf/value: vf/value
		]
	]
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

; --- test


a1: array 100 integer!
vali: declare struct! [int [integer!]]
vali/int: 2345
poke a1 1 as byte-ptr! vali
print ["at 1:"  picki a1 1 lf]

a2: array 100 float!
valf: declare struct! [value [float!]]
valf/value: 3.14159
poke a2 1 as byte-ptr! valf
print ["at 1:" pickf a2 1 lf]