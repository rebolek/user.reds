Red/System[
	Title: "substring.reds" 
	Author: "Boleslav Brezovsky" 
	About: "Collection of functions to work with substring structure"
	Date: 5-9-2013
	Notes: {
		All functions are prefixed with SB- (substring)

		Substring struct! is defined in following format:

		struct/count 	- number of substrings
		struct/start 	- pointer to array of pointers to substring starts
		struct/length 	- pointer to array of pointers to substring lengths
		struct/data 	- pointer to original string
	 
		Size of start and length arrays is predefined in BUFFER-SIZE.
		If buffer size is hit, function will just collect number of spaces 
		and will call itself with bigger buffer size .

		To get substring struct! use SB-SPLIT function.
		To read from substring struct!, use SB-PICK function.

		It's not possible to manipulate string using substring functions.
	}
]


; define SUBSTRING structure:

sb-string!: alias struct! [
	count		[integer!]				; number of items
	start		[pointer! [integer!]]	; pointer to item starts
	length		[pointer! [integer!]]	; pointer to item lengths
	data		[pointer! [integer!]]	; pointer to item contents
]


; functions:

sb-split: function [
	"Split string on character and return struct of substrings"
	string 		[c-string!]
	char 		[byte!]
	return:		[sb-string!]	"Structure for result"
	/local buffer-size
][
	buffer-size:	8				; predefined buffer
	sb-split-to-buffer string char buffer-size
]

sb-split-to-buffer: function [
	"Internal function used by SPLIT only"
	string 		[c-string!]
	char 		[byte!]
	buffer-size	[integer!]
	return:		[sb-string!]
	/local orig overflow? index next-index ret
][
	orig: string
	ret: as sb-string! allocate size? sb-string!
	ret/count:	0
	overflow?: false
	ret/start: as int-ptr! allocate buffer-size * size? integer!
	ret/length: as int-ptr! allocate buffer-size * size? integer!
	ret/start/1: as integer! string
	; main loop
	until [
		if string/1 = char [
			ret/count: ret/count + 1
			either ret/count > buffer-size [
				overflow?: true
			][
				index: ret/count
				next-index: ret/count + 1
				ret/start/next-index: as integer! string + 1
				ret/length/index: ret/start/next-index - ret/start/index - 1 ; also subtract matched char from length 
			]
		]
	; end condition	
		string: string + 1
		string/1 = null-byte
	]
	; set last count
	ret/count: ret/count + 1
	index: ret/count
	ret/length/index: (as integer! string) - ret/start/index

	if overflow? [
		; This should free old small buffer before allocating new
		; Why it does require byte-ptr! ?
		index: ret/count 					; store buffer size
		free as byte-ptr! ret
		ret: sb-split-to-buffer orig char index
	]
	ret
]

sb-pick: function [
	"Pick substring from struct returned by SPLIT"
	data	[sb-string!]	"Struct with substring informations"
	index	[integer!]	"Index of substring"
	return:	[c-string!]
	/local string [c-string!]
][
	; TODO: check boundaries
	string: as c-string! allocate data/length/index
	copy-memory as byte-ptr! string as byte-ptr! data/start/index data/length/index
	string
]