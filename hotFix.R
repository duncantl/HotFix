hotFix =
    # rf = list.files(srcDir, pattern = "\\.R$")
function(fn, srcDir = "../R", pkg = "GSPAutoTest")
{
    funs = CodeAnalysis::getFunctionDefs(srcDir)
    fun2 = funs[[fn]]
    ns = getNamespace(pkg)
#    fun2 = eval(fun, ns)
    browser()
    environment(fun2) = ns    
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
    fun2
}
