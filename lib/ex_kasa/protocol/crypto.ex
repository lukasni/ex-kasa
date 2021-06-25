defmodule ExKasa.Protocol.Crypto do
  @moduledoc """

  """
  require Bitwise

  import Bitwise, only: [^^^: 2]

  @initialization_vector 171

  def encrypt(command) do
    for <<i::8 <- command>>, reduce: {@initialization_vector, <<byte_size(command)::32>>} do
      {key, result} ->
        a = key ^^^ i
        {a, result <> <<a>>}
    end
    |> elem(1)
  end

  def decrypt(<<length::32, command::binary()>>) do
    {_, result} =
      for <<i::8 <- command>>, reduce: {@initialization_vector, ""} do
        {key, result} ->
          a = key ^^^ i
          {i, result <> <<a>>}
      end

    cond do
      length != byte_size(result) ->
        {:error, :length_mismatch}
      not String.printable?(result) ->
        {:error, :malformed_string}
      true ->
        {:ok, result}
    end
  end
end
