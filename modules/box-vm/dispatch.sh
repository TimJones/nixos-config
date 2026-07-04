# `vm [host] [-- qemu args...]` — dispatch to a per-host runner.
# Static script: VM_HOSTS (space-separated) and VM_DEFAULT_HOST are supplied via
# writeShellApplication's runtimeEnv, and each `vm-<host>` runner is on $PATH via
# runtimeInputs (see ./default.nix).
host="${1:-$VM_DEFAULT_HOST}"
[ "$#" -gt 0 ] && shift

if [ -z "$host" ]; then
  echo "usage: vm <host> [-- qemu args...]" >&2
  echo "hosts: $VM_HOSTS" >&2
  exit 1
fi

case " $VM_HOSTS " in
  *" $host "*) exec "vm-$host" "$@" ;;
  *)
    echo "unknown host: $host (have: $VM_HOSTS)" >&2
    exit 1
    ;;
esac
