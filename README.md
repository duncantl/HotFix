# HotFix

Others have, I'm sure, done this before, as have I, or at least the `hotFix()` function.

This small collection of functions basically allows me to 
+ make changes to a function in a package's source directory
+ hot-swap those changes to the function in an existing R session
  and have all the code use that updated function rather than
  the previously installed version.
  
This allows me to continue in an R session without having to 
+ end the R session, perhaps explicitly saving  variables
+ install the package, 
+ restart an R session
+ restore the state of the R session to continue from where I was
   + re-run code
   + load serialized data and then remove these intermediate files.

Restoring this state can be quite involved and a distraction.


The primary function is `hotFix()` and it  takes the name of a function (either as a string or a symbol) and then
+ determines the package in which it is located
+ finds the source directory for that package
+ reads the functions in that package
+ gets the current definition
+ replaces the currently installed version of the function with this new one
   in the package's namespace and also on the search path if the function
   is exported.

The function being updated does not have to be exported from the package.

One can specify the path to the package's source code in a call to `hotFix()`.
However, it is more convenient to have the function figure this out. 

`hotFix()` and its helper functions  determine the location of the source code for a package
by recursively searching for DESCRIPTION files in a set of identified directories where
I tend to do development. Rather than search these each time, we build a character vector **map** of 
directories, with the names being the package name, and we store this in an option in the R session.
And since these don't change very often, we write this to a file so it is available in other R sessions.

We do sometimes more than one R source code directory for the same package.
This happens when we clone a repository, copy it for various reasons, ...
When building the map, we resolve duplicates by keeping only the directory 
which has the most recent time-stamp on any file in the packages R/ directory.

BTW, we do need the name on the map and not just assume that the name of the package
is the same as the name of the directory.


