defmodule ExKasa do
  alias ExKasa.SmartDevice
  alias ExKasa.Protocol.Commands

  def update(%SmartDevice{} = device) do
    sysinfo = ExKasa.Protocol.send_receive(device, Commands.sysinfo)
    SmartDevice.new(device.ip, sysinfo)
  end

  def toggle(%SmartDevice{} = device) do
    device = update(device)

    case device.relay_state do
      1 ->
        turn_off(device)
        Map.put(device, :relay_state, 0)
      0 ->
        turn_on(device)
        Map.put(device, :relay_state, 1)
    end
  end

  def turn_on(%SmartDevice{} = device) do
    ExKasa.Protocol.send_receive(device, Commands.switch(:on))
    Map.put(device, :relay_state, :on)
  end

  def turn_off(%SmartDevice{} = device) do
    ExKasa.Protocol.send_receive(device, Commands.switch(:off))
    Map.put(device, :relay_state, :off)
  end

  def led_on(%SmartDevice{} = device) do
    ExKasa.Protocol.send_receive(device, Commands.led(:on))
    Map.put(device, :led_state, :on)
  end

  def led_off(%SmartDevice{} = device) do
    ExKasa.Protocol.send_receive(device, Commands.led(:off))
    Map.put(device, :led_state, :off)
  end
end
