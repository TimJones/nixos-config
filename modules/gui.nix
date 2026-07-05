{ lib, ... }:
{
  den.schema.host.options.hasGui = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether this host provides a graphical environment that user aspects can target.";
  };
}
