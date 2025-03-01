\name{mkMap}
\alias{mkMap}
\alias{findPackages}
\alias{updatePkgMap}
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
findPackages(dirs = PackageDirs,
             descriptions = lapply(dirs, findPackagesUnder),
             resolve = TRUE)
updatePkgMap(..., map = pkgMap(), out = PackageDirectoryMapFile, option = !is.null(getOption("PackageDirectoryMap")))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{pkgs}{typically a call to \code{findPackages}}
  \item{out}{the name of the file to which to serialize the result.
   If this is empty or \code{NA}, the result is not written to a file.}
 \item{option}{ a scalar logical value controlling whether
   the result is set as the session-level option \code{PackageDirectoryMap}.}
 \item{dirs}{a character vector of directory paths in which to recursively search for R package sourc code}
 \item{descriptions}{a list with an element for each directory search for R package source code.
     Each element is a named character vector of directory names with the names being the package name.}
 \item{resolve}{a scalar logical indicating whether
   the function should resolve cases where there are multiple source directories
   with the same package name.}
 \item{\dots}{collection of \code{pkgName = dirPath} values to insert into the map.}
 \item{map}{the package-directory map, a character vector of package names and paths to the
  package's source directory.}
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

