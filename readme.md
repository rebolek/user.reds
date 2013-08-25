# user.reds

User.reds is collection of useful functions and definitions. This file is distributed under public domain.

## Definitions

PI

## Math functions

### FLOAT-TO-INT

Converts float! value to integer!

Usage:

	int-value: float-to-int float-value

### INT-TO-FLOAT

Converts integer! value to float!

Usage:

	float-value: int-to-float int-value
	
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
	==8

## String functions

### EQUAL?

Compares two strings.

Usage:

	equal? string-1 string-2

### FIND

Find substring in string.

Usage:

	find "Hello world!" "world"
	== "world!"

That's all for now.