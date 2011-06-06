package opaque.native

NativeLib = {{
  sysname = %%native.get_sys_sysname%%
  nodename = %%native.get_sys_nodename%%
  release = %%native.get_sys_release%%
  machine = %%native.get_sys_machine%%

  mem_usage = %%native.get_memory_usage%%
}}


get_sys_sysname() = NativeLib.sysname()
get_sys_nodename() = NativeLib.nodename()
get_sys_release() = NativeLib.release()
get_sys_machine() = NativeLib.machine()
get_mem_usage() = NativeLib.mem_usage()/(1024*1024) // in megabytes
