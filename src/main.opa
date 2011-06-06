package opaque.main
import opaque.native
import opaque.user
import opaque.mathjax
import opaque.upskirt

@publish upskirt_entry() = 
  do Debug.jlog("Upskirting entry...")
  Upskirt.render_to_xhtml(Dom.get_value(#entry))

@client reload_entry() =
  v = upskirt_entry()
  do Dom.transform([#output <- v])
  do Dom.clear_value(#entry)
  do Debug.jlog("Now reloading mathjax...")
  MathJax.reload(#output)

start() = 
  mem = get_mem_usage()
  sysname  = get_sys_sysname()
  nodename = get_sys_nodename()
  release  = get_sys_release()
  machine  = get_sys_machine()

  <script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" />
  <h1>Hi! This server is using {mem}MB of RAM.</h1>
  <p>The server you're using is '{nodename}' (a {sysname}/{machine} machine, version {release})</p>
  <br/>
  <div id=#inputarea>
    <input id=#entry  onnewline={_ -> reload_entry()} />
    <div class="button" onclick={_ -> reload_entry()}>Submit</div>
  </div>
  <div id=#output></div>

server = Server.one_page_bundle("Opaque blog", [], [], start)
