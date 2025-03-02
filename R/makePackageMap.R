
if(FALSE)
{
    # Now takes 23 seconds with the additional
    # file checks for resolving duplicate directories for
    # same package.
    system.time(pkgs <- mkMap())
}


pkgName =
function(dir)
   read.dcf(dir)[1, "Package"]


PackageDirs = c("~/GitWorkingArea",
                "~/OGS/GradhubCode",
                "~/OGS/Eforms",
                "~/OGS/Slate",
                "~/Projects",
                "~/DSIProjects",
                "~/DSI",
                "~/Books",
                "~/Davis",
                "~/Personal/Retirement")

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
                              "~/Projects/NIMBLE/",
                              "~/Books/ComputationalCaseStudies/SampleCode/github",
                              "~/Books/NextLevelComputationalReasoning/SampleCode/github"))
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
    pkgs = mkMap(findPackages(resolve = FALSE),  out = NA)
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
