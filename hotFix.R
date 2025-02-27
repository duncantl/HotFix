hotFix =
    # rf = list.files(srcDir, pattern = "\\.R$")
function(fn, srcDir = "../R", pkg = "GSPAutoTest")
{
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

getPackageDir =
function(pkg,
         map = getOption("PackageDirectoryMap", readRDS(rds)),
         rds = "~/.R/PackageDirectoryMap.rds")    
{
#    message("locating source directory for ", pkg)
    map[pkg]
}


gitPkgs =
function()    
{
    pd = list.files("~/GitWorkingArea", full.names = TRUE)
    pd = pd[file.info(pd)$isdir]
    desc = file.path(pd, "DESCRIPTION")

    ex = file.exists(desc)
    names = sapply(desc[ex], pkgName)
    structure(desc[ex], names = unname(names))
}

pkgName =
function(dir)
   read.dcf(dir)[1, "Package"]


PackageDirs = c("~/GitWorkingArea",
                "~/OGS/GradhubCode",
                "~/OGS/Eforms",
                "~/DSIProjects",
                "~/Projects",
                "~/DSI")

findPackages =
function(dirs = PackageDirs,
         descriptions = lapply(dirs, findPackagesUnder))
{
    desc = unlist(descriptions)
    pkgNames = lapply(desc, function(x) try(pkgName(x), silent = TRUE))
    err = sapply(pkgNames, inherits, 'try-error')
    structure(dirname(desc[!err]), names = pkgNames[!err] )
}

findPackagesUnder =
function(dir)
{
   list.files(dir, pattern = "DESCRIPTION$", recursive = TRUE, full.names = TRUE)
}
