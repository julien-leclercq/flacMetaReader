defmodule FlacTest do
  alias Koop.Parsers.Flac
  use ExUnit.Case
  doctest Flac

  @flac_file "./test/support/panda_dub_die_brücke.flac"

  describe ".parse" do
    test "it correctly parses flac file" do
      alias Koop.Parser
      assert {:ok, %Koop.File{} = _track} = Parser.parse(Flac, @flac_file)
    end
  end

end
