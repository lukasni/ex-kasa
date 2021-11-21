defmodule ExKasa.Protocol.Commands do
  @moduledoc """
  Basic command helpers for the TP-Link SmartHome Protocol
  """

  def sysinfo do
    ~s({"system":{"get_sysinfo":null}})
  end

  def reboot(delay \\ 1) do
    ~s({"system":{"reboot":{"delay":#{delay}}}})
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

  def cloud_info() do
    ~s({"cnCloud":{"get_info":{}}})
  end

  def wlan_scan() do
    ~s({"netif":{"get_scaninfo":{"refresh":0}}})
  end

  def get_time() do
    ~s({"time":{"get_time":{}}})
  end

  def get_schedule() do
    ~s({"schedule":{"get_rules":{}}})
  end
end
