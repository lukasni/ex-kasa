defmodule ExKasa.Protocol do
  @moduledoc """

  """
  defdelegate encrypt(message), to: ExKasa.Protocol.Crypto
  defdelegate decrypt(message), to: ExKasa.Protocol.Crypto

end
