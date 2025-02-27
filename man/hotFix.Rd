\name{hotFix}
\alias{hotFix}
\title{
Dynamically update function in loaded package with version from the current source code.
}
\description{
  This hot-swaps the identified function during an R session
  by reading the latest version from the package's source code directory
  and then replacing the installed function in the package's namespace
  and on the search path if it is also loaded there.

  This uses a cached map of package name to source code directory
  created by \code{\link{mkMap}}.
}
\usage{
hotFix(fn, srcDir = "../R", pkg = "GSPAutoTest")
}
\arguments{
  \item{fn}{either the name of a function as a character vector
    or the function name as a name/symbol.
    The symbol does not have to be available on the search path
    as it will not be evaluated.
  }
  \item{srcDir}{the path to the directory containing the package's current source code.
    This does not have to be supplied and the function will find the directory.
  }
  \item{pkg}{
    The name of the package containing the function as a character vector of length 1.
    This can be provided if the function could be found  in more than one location.
  }
}
\details{
  This uses
\enumerate{  
  \item \code{\link[utils]{find}} and \code{\link[utils]{getAnywhere}} to find the object
  \item \code{getPackageDir} to find the package's source code
  \item \code{\link[CodeAnalysis]{getFunctionDefs}} to read the current source code
  \item \code{link{unlockBinding}}, \code{link{lockBinding}} and \code{link{assign}} to insert the
  new versions of the function.
}  
}
\value{
  The updated function, with an \code{Updated} attribute
  that gives the date and time in which we inserted it into the
  package's namespace.

  The purpose of this function is its side-effect of changing the definition
  of the specified function in the R package.
}
\author{
Duncan Temple Lang
}
\seealso{
\code{\link{mkMap}}, \code{\link{pkgMap}}
}
% \examples{}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
\keyword{programming}
\keyword{debugging}
