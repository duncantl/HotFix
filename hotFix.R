hotFix =
    # rf = list.files(srcDir, pattern = "\\.R$")
function(fn, srcDir = "../R", pkg = "GSPAutoTest")
{
    fn0 = substitute(fn)
    if(is.name(fn0))
        fn = as.character(fn0)

    if(missing(srcDir)) {
        if(!missing(pkg))
            pkg0 = getPackageDir(pkg)
        else
            pkg0 = findDir(fn)
        
        srcDir = file.path(pkg0, "R")
    }
    
    funs = CodeAnalysis::getFunctionDefs(srcDir)
    fun2 = funs[[fn]]
    ns = getNamespace(pkg)
    environment(fun2) = ns
    attr(fun2, "Updated") = Sys.time()
    if(fn %in% getNamespaceExports(ns)) {
        pkg2 = paste0("package:", pkg)
        e = as.environment(pkg2)
        unlockBinding(fn, e)
        assign(fn, fun2, pkg2)
        lockBinding(fn, e)        
    }
    
    unlockBinding(fn, ns)
    assign(fn, fun2, envir = ns)
    lockBinding(fn, ns)
    invisible(fun2)
}

findDir =
function(fn)    
{
    pkg = character()
    
    pos = find(fn)
    if(length(pos))
       pkg = pos[1]
    else {
        # So not on the search path. Presumably not exported.
        def = getAnywhere(fn)
        if(length(def))
            pkg = def$where[1]
    }
    
    if(length(pkg))
       getPackageDir(gsub("^(namespace|package):", "", pkg))
    else
        stop("Can't find ", fn)
    
}

PackageDirectoryMapFile = "~/.R/PackageDirectoryMap.rds"

pkgMap =
function()
    readRDS(PackageDirectoryMapFile)

getPackageDir =
function(pkg,
         map = getOption("PackageDirectoryMap", readRDS(rds)),
         rds = PackageDirectoryMapFile)    
{
    map[pkg]
}




########
gitPkgs =
    # Not used.
function()    
{
    pd = list.files("~/GitWorkingArea", full.names = TRUE)
    pd = pd[file.info(pd)$isdir]
    desc = file.path(pd, "DESCRIPTION")

    ex = file.exists(desc)
    names = sapply(desc[ex], pkgName)
    structure(desc[ex], names = unname(names))
}
