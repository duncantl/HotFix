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
         descriptions = lapply(dirs, findPackagesUnder),
         resolve = TRUE)
{
    desc = unlist(descriptions)
    
    pkgNames = lapply(desc, function(x) try(pkgName(x), silent = TRUE))
    err = sapply(pkgNames, inherits, 'try-error')
    pkgs = structure(dirname(desc[!err]), names = pkgNames[!err] )
    if(resolve)
        pkgs = resolveDupPkgs(pkgs)

    pkgs
}

findPackagesUnder =
    function(dir, exclude = c("~/Projects/R/", "CRAN/XML", "~/Projects/CompilingR-broken/", "~/Projects/RepRes/",
                              "~/Projects/NIMBLE/"))
{
    desc = list.files(dir, pattern = "DESCRIPTION$", recursive = TRUE, full.names = TRUE)

    # was normalizePath but that requires actual files, not parts of paths such as CRAN/XML
    # So use path.expand to replace ~
    rx = paste(path.expand(exclude), collapse = "|")
    desc = desc[!grepl(rx, desc)]

    dir = dirname(desc)
    dir = dir[!grepl("_orig/?$", dir)]
    dir = dir[!grepl("\\.Rcheck/", dir)]    
    
    rex = file.exists(file.path(dir, "R"))
    dex = file.exists(file.path(dir, "data"))
    isRPkg = rex | dex
    desc = desc[isRPkg]
}


if(FALSE)
{
    # Now takes 23 seconds with the additional
    # file checks for resolving duplicate directories for
    # same package.
    system.time(pkgs <- mkMap())
}

mkMap = 
function(pkgs = findPackages(),
         out = PackageDirectoryMapFile,
         option = !is.null(getOption("PackageDirectoryMap")))
{
    if(length(out) && !is.na(out))
        saveRDS(pkgs, out)

    # set the option?
    if(option)
        options(PackageDirectoryMap = pkgs)
    
    pkgs
}

if(FALSE) {
    pkgs = mkMap()
    g = split(pkgs, names(pkgs))
    table(nels <- sapply(g, length))
    # 669 but 164 have unique name
    # rest have duplicates.
    # Excluded some more. Down to 496 with 181 unique.
    # The most is now 8 = pkgA

    g2 = resolveDupPkgs(pkgs)
    any(duplicated(names(g2))) == FALSE
    is.character(g2)
    any(duplicated(g2)) == FALSE
}


resolveDupPkgs =
function(pkgs)
{
    tapply(pkgs, names(pkgs), resolveDupPkgLocation)
}

resolveDupPkgLocation =
function(dirs)
{
    tm = sapply(file.path(dirs, "R"),  mostRecentTimeStamp)
    dirs[which.max(tm)]
}

mostRecentTimeStamp =
function(dir)
{
    info = file.info(list.files(dir, full.names = TRUE))
    if(nrow(info) > 0)
        max(unlist(info[, c("mtime", "ctime")]))
    else
        -1
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
