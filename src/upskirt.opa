package opaque.upskirt

@server Upskirt = {{
  render             = %%upskirt.render_str%%
  render_to_xhtml(s) = Xhtml.to_xhtml({content_unsafe = render(s)})
}}
