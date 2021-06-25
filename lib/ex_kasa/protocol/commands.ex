defmodule ExKasa.Protocol.Commands do
  @moduledoc false

  def sysinfo do
    ~s({"system":{"get_sysinfo":null}})
  end
end
