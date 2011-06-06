
NativeLib = {{
  sysname = %%native.get_sys_sysname%%
  nodename = %%native.get_sys_nodename%%
  release = %%native.get_sys_release%%
  machine = %%native.get_sys_machine%%

  mem_usage = %%native.get_memory_usage%%
}}

start() = 
  mem = NativeLib.mem_usage()/(1024*1024) // in megabytes
  sysname  = NativeLib.sysname()
  nodename = NativeLib.nodename()
  release  = NativeLib.release()
  machine  = NativeLib.machine()

  <h1>Hi! This server is using {mem}MB of RAM.</h1>
  <h2>The server you're using is {nodename} ({sysname}/{machine}, v{release})</h2>

server = Server.one_page_bundle("Opaque blog", [], [], start)
