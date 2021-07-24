defmodule ExKasa.SmartDevice do
  @moduledoc false

  defstruct [
    :ip,
    :alias,
    :device_name,
    :model,
    :mac,
    :hardware_version,
    :relay_state,
    :raw_sysinfo
  ]

  def new({o1,o2,o3,o4}, sysinfo) do
    new("#{o1}.#{o2}.#{o3}.#{o4}", sysinfo)
  end

  def new(ip, sysinfo) do
    sysinfo = sysinfo["system"]["get_sysinfo"]
    struct(__MODULE__,
      raw_sysinfo: sysinfo,
      ip: ip,
      alias: sysinfo["alias"],
      device_name: sysinfo["dev_name"],
      model: sysinfo["model"],
      mac: sysinfo["mac"],
      relay_state: sysinfo["relay_state"],
      led_off: sysinfo["led_off"]
    )
  end
end
