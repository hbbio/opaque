package opaque.main
import opaque.native
import opaque.user
import opaque.mathjax

unsafeStrToXhtml(s : string) = Xhtml.to_xhtml({content_unsafe = s})
unsafeDomToXhtml(elem : dom) = unsafeStrToXhtml(Dom.get_value(elem))

@client change() =
  do Dom.transform([#output <- unsafeDomToXhtml(#entry)])
  do Dom.clear_value(#entry)
  do Debug.jlog("Reloading mathjax div...")
  MathJax.reload(Dom.get_id(#output))

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
    <input id=#entry  onnewline={_ -> change()} />
    <div class="button" onclick={_ -> change()}>Submit</div>
  </div>
  <div id=#output></div>

server = Server.one_page_bundle("Opaque blog", [], [], start)
