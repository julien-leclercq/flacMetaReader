defmodule Koop.Parser do
  @moduledoc """
    Behaviour for track parsers
  """
  alias Kaur.Result
  import Result

  @type parsing_result :: Result.result_tuple()
  @callback hydrate(Koop.File.t, binary) :: Result.result_tuple()

  @spec parse(module, Path.t) :: parsing_result
  def parse(parser, path) do
    case File.open(path) do
      {:ok, io_device} ->
        io_device
        |> IO.binread(:all)
        |> hydrate(parser)
      {:error, posix} -> error(posix)
    end
  end

  @spec hydrate(binary, module) :: parsing_result
  defp hydrate(bytes, parser), do: parser.hydrate(Koop.File.new(), bytes)

end
