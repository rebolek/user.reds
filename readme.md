# user.reds

User.reds is collection of useful functions and definitions.

## Definitions

PI

CRLF

## Math functions

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

### LOAD-INT

Converts string to integer!

Usage:
	
	load-int "123"
	== 123

### FORM-INT

Converts integer! to readable string

Usage:

	form-int 123
	== "123"


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

## String functions

### NEXT, BACK

Move one position forward or backward in string.
**NOTE:** This is just simple pointer arithmetics and doesn't check for boundaries!

Usage:

	next "adamov"
	== "damov"

### EQUAL-STRING?

Compares two strings.

Usage:

	equal-string? string-1 string-2

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

### COUNT-CHAR

Count character occurrence in string.

Usage: 

	count-char "There are three spaces" #" "
	== 3


## License

This file is distributed under same [BSL license](https://github.com/rebolek/user.reds/blob/master/BSL-license.txt) as Red/System runtime.