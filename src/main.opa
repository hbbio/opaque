package opaque.main
import opaque.native
import opaque.user

start() = 
  mem = get_mem_usage()
  sysname  = get_sys_sysname()
  nodename = get_sys_nodename()
  release  = get_sys_release()
  machine  = get_sys_machine()

  <h1>Hi! This server is using {mem}MB of RAM.</h1>
  <h3>The server you're using is '{nodename}' (a {sysname}/{machine} machine, version {release})</h3>

server = Server.one_page_bundle("Opaque blog", [], [], start)
