defmodule ExKasa do
  require Bitwise

  def send_receive(command, host, port \\ 9999) do
    {:ok, socket} = :gen_tcp.connect(String.to_charlist(host), port, [:binary])

    :gen_tcp.send(socket, ExKasa.Protocol.Crypto.encrypt(command))

    receive do
      {:tcp, ^socket, message} ->
        ExKasa.Protocol.Crypto.decrypt(message)
    after
      5000 ->
        {:error, :timeout}
    end

  end
end
