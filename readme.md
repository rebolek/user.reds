# user.reds

User.reds is collection of useful functions and definitions.

## Definitions

PI

CRLF

## Math functions

### ABS, FABS

Return absolute value of number (integer! and float! version)

Usage:

	abs -3
	== 3
	
	fabs -3.14
	== -3.0

### **

Return x power y (integer! version only)

Usage:

	2 ** 3
	== 8

### NEGATE

Negate integer! number

	negate 23
	== -23

## Conversion


### FLOAT-TO-INT

Converts float! value to integer!

Usage:

	float-to-int 3.14
	== 3

### INT-TO-FLOAT

Converts integer! value to float!

Usage:

	int-to-float 3
	== 3.0

### FORM-INT

Converts integer! to readable string

Usage:

	form-int 123
	== "123"

### LOAD-INT

Converts string to integer!

Usage:
	
	load-int "123"
	== 123

### LOAD-DIGIT

Convert string with single digit (0-9) to byte!

Usage:

	load-byte "6"
	== 6

### LOAD-BYTE

Convert string with byte value (0-255) to byte!

Usage:

	load-byte "123"
	== 123	

## String functions

### NEXT, BACK

Move one position forward or backward in string.
**NOTE:** This is just simple pointer arithmetics and doesn't check for boundaries!

Usage:

	next "adamov"
	== "damov"

### END?

Check if first value of given c-string! is null-byte

Usage:

	end? next "x"
	== true

### EQUAL-STRING?

Compares two strings.

Usage:

	equal-string? string-1 string-2

### MATCH-STRING

Check if the beginnign of string is same other string.

Usage:

	match-string "Hello world!" "Hello"
	== true

### FIND-STRING

Find substring in string.

Usage:

	find-string "Hello world!" "world"
	== "world!"

### REVERSE-STRING

Return new string that is reversed copy of original string

Usage:

	reverse-string "BRNO"
	== "ONRB"

### CHANGE-STRING, CHANGE-STRING-AT

Change begining of the string with new value, or change string at index with new value

Usage:

	change-string "Rebol" "Red"
	== "Redol"
	change-string-at "Rebol" "d" 3
	== "Redol"

### COPY-STRING-TO

Copy substring to given match

Usage:

	copy-string-to "Hello, World" ","
	== "Hello"


### COUNT-CHAR

Count character occurrence in string.

Usage: 

	count-char "There are three spaces" #" "
	== 3

## License

This file is distributed under same [BSL license](https://github.com/rebolek/user.reds/blob/master/BSL-license.txt) as Red/System runtime.