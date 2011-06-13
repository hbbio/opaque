##register get_sys_sysname: -> string
external get_sys_sysname : unit -> string = "opaque_get_sys_sysname"

##register get_sys_nodename: -> string
external get_sys_nodename : unit -> string = "opaque_get_sys_nodename"

##register get_sys_release: -> string
external get_sys_release : unit -> string = "opaque_get_sys_release"

##register get_sys_machine: -> string
external get_sys_machine : unit -> string = "opaque_get_sys_machine"

##register get_memory_usage: -> int
external get_memory_usage : unit -> int = "opaque_get_memory_usage"
