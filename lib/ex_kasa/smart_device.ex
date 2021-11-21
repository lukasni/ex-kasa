defmodule ExKasa.SmartDevice do
  @moduledoc """
  SmartDevice struct used by higher level functions
  """

  @type t() :: %__MODULE__{
    ip: String.t(),
    alias: String.t(),
    device_name: String.t(),
    model: String.t(),
    mac: String.t(),
    relay_state: :on | :off,
    led_state: :on | :off,
    raw_sysinfo: %{String.t() => String.t()}
  }

  defstruct [
    :ip,
    :alias,
    :device_name,
    :model,
    :mac,
    :hardware_version,
    :relay_state,
    :led_state,
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
      relay_state: on_off(sysinfo["relay_state"]),
      led_state: on_off(sysinfo["led_off"])
    )
  end

  defp on_off(1), do: :on
  defp on_off(0), do: :off
end
