# Injects the chosen TPM device into $QEMU_OPTS, then boots the host VM.
# Static script: RUN_VM and VM_HOSTNAME are supplied via writeShellApplication's
# runtimeEnv (see ../box-vm/default.nix). See that file's header for VM_TPM.
tpm_mode="${VM_TPM:-emulated}"
tpm_opts=""

case "$tpm_mode" in
  none) ;;
  passthrough)
    dev="${VM_TPM_DEV:-/dev/tpm0}"
    if [ ! -e "$dev" ]; then
      echo "VM_TPM=passthrough but $dev not found on this host" >&2
      exit 1
    fi
    tpm_opts="-tpmdev passthrough,id=tpm0,path=$dev,cancel-path=/sys/class/tpm/${dev##*/}/cancel -device tpm-tis,tpmdev=tpm0"
    ;;
  emulated)
    state="$(mktemp -d)"
    sock="$state/swtpm-sock"
    trap 'kill "$(cat "$state/swtpm.pid" 2>/dev/null)" 2>/dev/null || true; rm -rf "$state"' EXIT
    swtpm socket --tpmstate dir="$state" --ctrl "type=unixio,path=$sock" \
      --tpm2 --daemon --pid "file=$state/swtpm.pid"
    for _ in $(seq 1 50); do
      [ -S "$sock" ] && break
      sleep 0.1
    done
    tpm_opts="-chardev socket,id=chrtpm,path=$sock -tpmdev emulator,id=tpm0,chardev=chrtpm -device tpm-tis,tpmdev=tpm0"
    ;;
  *)
    echo "unknown VM_TPM=$tpm_mode (use: emulated | passthrough | none)" >&2
    exit 1
    ;;
esac

export QEMU_OPTS="$tpm_opts ${QEMU_OPTS:-}"
exec "$RUN_VM/bin/run-$VM_HOSTNAME-vm" "$@"
