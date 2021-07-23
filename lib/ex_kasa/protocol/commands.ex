defmodule ExKasa.Protocol.Commands do
  @moduledoc false

  def sysinfo do
    ~s({"system":{"get_sysinfo":null}})
  end

  def reboot do
    ~s({"system":{"reboot":{"delay":1}}})
  end

  def switch(:on) do
    ~s({"system":{"set_relay_state":{"state":1}}})
  end

  def switch(:off) do
    ~s({"system":{"set_relay_state":{"state":0}}})
  end

  def led(:on) do
    ~s({"system":{"set_led_off":{"off":0}}})
  end

  def led(:off) do
    ~s({"system":{"set_led_off":{"off":1}}})
  end
end
