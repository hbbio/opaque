##register mj_reload_dom : string -> void
##args(s)
{
    MathJax.Hub.Queue(["Typeset", MathJax.Hub, s]);
}
