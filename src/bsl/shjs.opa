package opaque.bsl.shjs

@client SHJS = {{
  highlight_page = %%shjs.shjs_highlight_doc%%
  highlight() = 
    do Debug.jlog("Rehighlighting page")
    highlight_page()
}}
