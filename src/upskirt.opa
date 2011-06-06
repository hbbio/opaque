package opaque.upskirt

@server Upskirt = {{
  render             = %%upskirt.render_str%%
  render_to_xhtml(s) = 
    do Debug.jlog("Upskirt'd an entry")
    Xhtml.of_string_unsafe(render(s))
}}
