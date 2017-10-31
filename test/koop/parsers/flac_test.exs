defmodule FlacTest do
  alias Koop.Parsers.Flac
  use ExUnit.Case
  doctest Flac

  @flac_file "test/support/panda_dub_die_brücke.flac"

  describe ".parse" do
    test "it correctly parses flac file" do
      assert Koop.Parser.parse(Flac, @flac_file) == @flac_file_infos
    end
  end

end
