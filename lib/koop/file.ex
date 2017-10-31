defmodule Koop.File do
  defstruct [:track, :vendor]

  @type t :: %__MODULE__{
    track: Koop.Track.t,
    vendor: String.t
  }

  def new, do: %__MODULE__{track: Koop.Track.new()}

  @spec set_vendor(t, String.t) :: t
  def set_vendor(koop_file, vendor), do: %{koop_file | vendor: vendor}

  @spec update_track(t, (Koop.Track.t -> Koop.Track.t)) :: t
  def update_track(%__MODULE__{track: track} = koop_file, updater) do
    %{koop_file | track: updater.(track)}
  end

end
