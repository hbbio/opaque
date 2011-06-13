package opaque.main
import opaque.admin
import opaque.layout

// plugins
import opaque.bsl.native
import opaque.bsl.mathjax
import opaque.bsl.shjs
import opaque.bsl.upskirt

room = Network.cloud("room"): Network.network(xhtml)

@client broadcast(s) =
  do Dom.transform([#output <- s])
  do MathJax.reload(#output)
  SHJS.highlight()

update() =
  v = Upskirt.render_to_xhtml(Dom.get_value(#entry))
  do Network.broadcast(v, room)
  Dom.clear_value(#entry)

mainpage() = Layout.styled_page("Blog - main page",
  <p>Result:</p><br/><div id=#output onready={_ -> Network.add_callback(broadcast, room)}></div>
  <br/>
  <div id=#inputarea>
    <textarea rows=20 cols=80 id=#entry /><br/>
    <button type="button" onclick={_ -> update()}>Submit</button>
  </div>
 )

start =
  | {path = [] ... }           -> mainpage()
  | {path = ["admin" | _] ...} -> Admin.mainpage() 
  | {path = _ ...}             -> mainpage()

server = Server.of_bundle([@static_resource_directory("res")])
server = Server.simple_dispatch(start)
