# can also consider pgkMap<- function(x, ..., value)
updatePkgMap =
function(...,
         map = pkgMap(),    
         out = PackageDirectoryMapFile,
         option = !is.null(getOption("PackageDirectoryMap")))
{
    vals = unlist(list(...))
    if(is.null(names(vals)))
        stop("no names identifying the package(s)")
    if(any(w <- names(vals) == ""))
        stop("no package name for ", paste(vals[w], collapse = ", "))

    map[names(vals)] = vals
    browser()
    mkMap(map, out, option)
}
