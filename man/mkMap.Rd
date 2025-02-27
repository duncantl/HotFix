\name{mkMap}
\alias{mkMap}
\title{
Compute a map of package source code directory and package name.
}
\description{
  With a collection of directories,
  this searches recursively for directories containing
  R package source code, i.e., with a \code{DESCRIPTION}
  and \code{R} or \code{data} directory.
  It then determines the name of each package
  and, in the case of multiple directories for a given package name,
  finds the directory with the most recent time-stamp on any of the
  files in the \code{R/} directory.
  We then have a map of package name to package source code directory.

  We use this in \code{\link{hotFix}} to find the source code
  for a given function to read the most recent version of that
  function.
}
\usage{
mkMap(pkgs = findPackages(), out = PackageDirectoryMapFile, option = !is.null(getOption("PackageDirectoryMap")))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\itemize{  
  \item{pkgs}{typically a call to \code{findPackages}}
  \item{out}{the name of the file to which to serialize the result.
   If this is empty or \code{NA}, the result is not written to a file.}
 \item{option}{ a scalar logical value controlling whether
   the result is set as the session-level option \code{PackageDirectoryMap}.
 }
}
}
\details{
}
\value{
A named character vector. See \code{\link{pkgMap}} for a description.
}
\author{
Duncan Temple Lang
}

\seealso{
  \code{\link{pkgMap}}
}
%\examples{}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
\keyword{programming}

