package opaque.mathjax

@client MathJax = {{
  reload_id = %%mathjax.mj_reload_dom%%
  reload(elem) = 
    do Debug.jlog("Now reloading mathjax")
    reload_id(Dom.get_id(elem))
}}
