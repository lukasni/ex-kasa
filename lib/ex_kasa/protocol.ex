defmodule ExKasa.Protocol do
  @moduledoc """

  """
  defdelegate encrypt(message), to: ExKasa.Protocol.Crypto
  defdelegate decrypt(message), to: ExKasa.Protocol.Crypto

  def send_receive(%ExKasa.SmartDevice{} = switch, command, port \\ 9999) do

    {:ok, socket} = :gen_tcp.connect(String.to_charlist(switch.ip), port, [:binary])

    :gen_tcp.send(socket, ExKasa.Protocol.Crypto.encrypt(command))

    receive do
      {:tcp, ^socket, message} ->
        with {:ok, json} = ExKasa.Protocol.Crypto.decrypt(message),
             {:ok, decoded} = Jason.decode(json) do
          decoded
        end
    after
      5000 ->
        {:error, :timeout}
    end
  end
end
