\name{pkgMap}
\alias{pkgMap}
\title{
Get the cached map of package name to directory of source code.
}
\description{
  This returns the previously computed character vector
  of package directories and the package names.
}
\usage{
pkgMap()
}
\value{
  A named character vector. The values are the directory paths
  to the source code for the package;
  the names are the package names which may differ
  from the directory names.
}
\author{
Duncan Temple Lang
}
\seealso{
\code{\link{mkMap}}
}
\examples{
 m = pkgMap()
 m["XML"]
}
\keyword{programming}
