package opaque.native

NativeLib = {{
  sysname = %%native.get_sys_sysname%%
  nodename = %%native.get_sys_nodename%%
  release = %%native.get_sys_release%%
  machine = %%native.get_sys_machine%%

  mem_usage = %%native.get_memory_usage%%
}}
