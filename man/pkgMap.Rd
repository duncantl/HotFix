\name{pkgMap}
\alias{pkgMap}
\alias{getPackageDir}
\title{
Get the cached map of package name to directory of source code.
}
\description{
  This returns the previously computed character vector
  of package directories and the package names.
}
\usage{
pkgMap()
getPackageDir(pkg, map = getOption("PackageDirectoryMap", readRDS(rds)),
              rds = PackageDirectoryMapFile)    
}
\arguments{
 \item{pkg}{a scalar character vector giving the name of a package}
 \item{map}{a named character vector mapping package names to R source code directory paths.}
 \item{rds}{the full path identifying the file in which the \code{map} was serialized previously.}    
}

\value{
 \code{pkgMap} returns a named character vector. The values are the directory paths
  to the source code for the package;
  the names are the package names which may differ
  from the directory names.

  \code{getPackageDir} returns a  character  vector of length 1
  identifying the R source code directory for the specified package
  name, or \code{NA}.
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
