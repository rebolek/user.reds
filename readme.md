# user.reds

## Definitions

user.reds defines datatypes as integer ids save as in Red/system compiler.

## Array functions

user.reds defines three functions for working with arrays.

### ARRAY

ARRAY creates new array.

Usage:

	<name>: array <length> <type>
	
	<length>	: length of array (number of items)
	<type>	: datatype of array (named values from definitions can be used here
	
Example:

	int-array: array 50 integer!
	float-array: array 256 float!

ARRAY return array struct of this structure:

	array: declare struct! [
		length	[integer!]
		type		[integer!]
		cell-size	[integer!]
	]

### POKE

POKE stores value into array at given index.

Usage:

	poke <array> <index> <value>

### PICK

PICK reads value from array at given index.

Usage:

	pick <array> <index>
	
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