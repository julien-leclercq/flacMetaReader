defmodule Koop.Parser do
  @moduledoc """
    Behaviour for track parsers
  """
  alias Koop.Utils.Result
  import Result

  @type parsing_result :: Result.typed_result_tuple(Koop.File.t)
  @callback hydrate(Koop.File.t, binary) :: Result.typed_result_tuple(Koop.File.t)

  @spec parse(module, Path.t) :: parsing_result
  def parse(parser, path) do
    case File.open(path) do
      {:ok, io_device} ->
        io_device
        |> IO.binread(:all)
        |> fn bytes -> parser.hydrate(Koop.File.new, bytes) end.()
      {:error, posix} -> error(posix)
    end
  end
end
