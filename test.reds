Red/System[
	Title: "user.reds test" 
	Author: "Boleslav Brezovsky" 
	Date: 25-8-2013
]

#include %user.reds

a: pi
print [
	"number: " a newline
	"abs: " a " = " fabs a newline
	"int: " a " = " float-to-int a newline
]