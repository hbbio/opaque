package opaque.main
import opaque.native
import opaque.user
import opaque.mathjax
import opaque.upskirt

room = Network.cloud("room"): Network.network(xhtml)

@client broadcast(s) =
  do Dom.transform([#output <- s])
  do Debug.jlog("Now reloading mathjax...")
  MathJax.reload(#output)

update() =
  do Debug.jlog("Upskirting entry...")
  v = Upskirt.render_to_xhtml(Dom.get_value(#entry))
  do Network.broadcast(v, room)
  Dom.clear_value(#entry)

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
    <input id=#entry  onnewline={_ -> update()} />
    <div class="button" onclick={_ -> update()}>Submit</div>
  </div>
  <div id=#output onready={_ -> Network.add_callback(broadcast, room)}></div>

server = Server.one_page_bundle("Opaque blog", [], [], start)
