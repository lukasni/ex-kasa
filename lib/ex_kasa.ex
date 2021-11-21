defmodule ExKasa do
  @moduledoc """
  An elixir client for the proprietary TP-Link Smart Home protocol to control TP-Link HS100, HS200 and similar devices in the TP-Link Kasa line.

  This project is only possible thanks to the reverse engineering work done by softScheck at https://github.com/softScheck/tplink-smartplug

  Devices can be discovered using `ExKasa.Discover.discover/0`

      devices = ExKasa.Discover.discover()

  Commands can be sent to devices using `ExKasa.Protocol.send_receive/2`. Basic commands are available in `ExKasa.Protocol.Commands`.

      devices
      |> Enum.at(0)
      |> ExKasa.Protocol.send_receive(ExKasa.Protocol.Commands.sysinfo)

  This module also provides a number of shorthand functions for common operations such as toggling a switch or turning the status LED on or off.
  """
  alias ExKasa.SmartDevice
  alias ExKasa.Protocol.Commands

  @doc """
  Runs a device discovery on the local network and tries to find a Kasa device whose alias matches the given keyword.

  Returns a ExKasa.SmartDevice struct or nil

  ## Examples

      iex> ExKasa.find("Dining Room")
      %ExKasa.SmartDevice{alias: "Dining Room"}

      iex> ExKasa.find("dining")
      %ExKasa.SmartDevice{alias: "Dining Room"}

      iex> ExKasa.find("notaroom")
      nil
  """
  @spec find(String.t(), keyword) :: list(ExKasa.SmartDevice.t()) | nil
  def find(name, discover_opts \\ []) do
    ExKasa.Discover.discover(discover_opts)
    |> Enum.find(fn device ->
      String.starts_with?(String.downcase(device.alias), String.downcase(name))
    end)
  end

  @doc """
  Fetches the current sysinfo for an ExKasa.SmartDevice struct
  """
  @spec update(ExKasa.SmartDevice.t()) :: ExKasa.SmartDevice.t()
  def update(%SmartDevice{} = device) do
    sysinfo = ExKasa.Protocol.send_receive(device, Commands.sysinfo)
    SmartDevice.new(device.ip, sysinfo)
  end

  @doc """
  Toggles the relay on a SmartDevice. If the relay is currently off it will be turned on and vice versa.

  Returns an updated SmartDevice struct with the new relay state.
  """
  @spec toggle(ExKasa.SmartDevice.t()) :: ExKasa.SmartDevice.t()
  def toggle(%SmartDevice{} = device) do
    device = update(device)

    case device.relay_state do
      :on ->
        turn_off(device)
        Map.put(device, :relay_state, :off)
      :off ->
        turn_on(device)
        Map.put(device, :relay_state, :on)
    end
  end

  @doc """
  Turns on the relay on a smart device.

  Returns an updated SmartDevice struct with `relay_state: :on`
  """
  @spec turn_on(ExKasa.SmartDevice.t()) :: ExKasa.SmartDevice.t()
  def turn_on(%SmartDevice{} = device) do
    ExKasa.Protocol.send_receive(device, Commands.switch(:on))
    Map.put(device, :relay_state, :on)
  end


  @doc """
  Turns off the relay on a smart device.

  Returns an updated SmartDevice struct with `relay_state: :off`
  """
  @spec turn_off(ExKasa.SmartDevice.t()) :: ExKasa.SmartDevice.t()
  def turn_off(%SmartDevice{} = device) do
    ExKasa.Protocol.send_receive(device, Commands.switch(:off))
    Map.put(device, :relay_state, :off)
  end


  @doc """
  Turns on the status led on a smart device.

  Returns an updated SmartDevice struct with `led_state: :on`
  """
  @spec led_on(ExKasa.SmartDevice.t()) :: ExKasa.SmartDevice.t()
  def led_on(%SmartDevice{} = device) do
    ExKasa.Protocol.send_receive(device, Commands.led(:on))
    Map.put(device, :led_state, :on)
  end

  @doc """
  Turns off the status led on a smart device.

  Returns an updated SmartDevice struct with `led_state: :off`
  """
  @spec led_off(ExKasa.SmartDevice.t()) :: ExKasa.SmartDevice.t()
  def led_off(%SmartDevice{} = device) do
    ExKasa.Protocol.send_receive(device, Commands.led(:off))
    Map.put(device, :led_state, :off)
  end
end
