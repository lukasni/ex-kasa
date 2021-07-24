defmodule ExKasa.Discover do
  @moduledoc """
  {:ok ,socket} = :gen_udp.open(0, [:binary, {:broadcast, true}])
  :gen_udp.send(socket, {255, 255, 255, 255}, 9999, discover_message)
  """

  @discover_message ExKasa.Protocol.Commands.sysinfo()

  @default_opts [address: {255, 255, 255, 255}, port: 9999, message: @discover_message]

  require Logger

  def discover(options \\ []) do
    options = Keyword.merge(@default_opts, options)

    {:ok, socket} = :gen_udp.open(0, [:binary, {:broadcast, true}])

    <<_::32, message::binary>> = ExKasa.Protocol.encrypt(options[:message])

    :gen_udp.send(socket, options[:address], options[:port], message)

    receive_loop([])
  end

  defp receive_loop(acc) do
    receive do
      {:udp, _socket, ip, _port, message} ->
        handle_response(acc, ip, message)
      _ ->
        receive_loop(acc)
    after
      2000 ->
        acc
    end
  end

  defp handle_response(acc, ip, message) do
    message = <<byte_size(message)::32>> <> message
    with {:ok, decrypted} <- ExKasa.Protocol.decrypt(message),
         {:ok, decoded} <- Jason.decode(decrypted),
         device <- ExKasa.SmartDevice.new(ip, decoded) do
      receive_loop([device | acc])
    else
      error ->
        Logger.debug(error)
        receive_loop(acc)
    end
  end
end
