package opaque.main
import opaque.user
import opaque.native
import opaque.mathjax
import opaque.shjs
import opaque.upskirt

room = Network.cloud("room"): Network.network(xhtml)

@client broadcast(s) =
  do Dom.transform([#output <- s])
  do MathJax.reload(#output)
  SHJS.highlight()

update() =
  v = Upskirt.render_to_xhtml(Dom.get_value(#entry))
  do Network.broadcast(v, room)
  Dom.clear_value(#entry)

mainpage() = Resource.styled_page("Opaque blog - Main page", ["res/sh_nedit.min.css", "res/style.css"],
  mem = get_mem_usage()
  sysname  = get_sys_sysname()
  nodename = get_sys_nodename()
  release  = get_sys_release()
  machine  = get_sys_machine()

  <script type="text/javascript" src="res/sh_main.min.js"/>
  <script type="text/javascript" src="res/sh_haskell.min.js"/>
  <script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"/>

  <h1>Hi! This server is using {mem}MB of RAM.</h1>
  <p>The server you're using is '{nodename}' (a {sysname}/{machine} machine, version {release})</p>
  <br/>
  <p>Result:</p><br/><div id=#output onready={_ -> Network.add_callback(broadcast, room)}></div>
  <br/>
  <div id=#inputarea>
    <textarea rows=50 cols=80 id=#entry /><br/>
    <button type="button" onclick={_ -> update()}>Submit</button>
  </div>
 )

start =
  | {path = [] ... }           -> mainpage()
  | {path = ["admin" | _] ...} -> User.loginpage() 
  | {path = _ ...}             -> mainpage()

server = Server.of_bundle([@static_resource_directory("res")])
server = Server.simple_dispatch(start)
/*
server = Server.one_page_bundle("Opaque blog",[@static_resource_directory("res")],
       ["res/sh_nedit.min.css", "res/style.css"], start)
*/
