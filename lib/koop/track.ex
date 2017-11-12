defmodule Koop.Track do

  @moduledoc"""
    Track metadata manipulation
  """
  alias Koop.Track


  defstruct [
    :album,
    :date,
    :tracknumber,
    :title,
    artists: [],
    albumartists: [],
    version: [],
    copyright: [],
    performers: [],
    licence: [],
    organizations: [],
    description: [],
    location: [],
    contacts: [],
    isrc: [],
    comments: [],
  ]

  @type album        :: String.t
  @type albumartists :: [artist]
  @type artists      :: [artist]
  @type artist       :: String.t
  @type date         :: String.t
  @type tracknumber  :: String.t
  @type title        :: String.t
  @type version      :: String.t
  @type copyright    :: String.t
  @type licence      :: String.t
  @type organization :: String.t
  @type description  :: String.t
  @type location     :: String.t
  @type contact      :: String.t
  @type isrc         :: String.t
  @type comment      :: String.t

  @type t :: %Track{
    tracknumber: tracknumber | nil,
    album: album | nil,
    artists: artists,
    albumartists: albumartists,
    date: date | nil,
    title: title | nil,
    version: [version],
    copyright: [copyright],
    performers: [artist],
    licence: [licence],
    organizations: [organization],
    description: [description],
    location: [location],
    contacts: [contact],
    isrc: [isrc],
    comments: [comment],
  }

  @spec new():: t
  def new, do: %__MODULE__{}

  @spec add_artist(t, artist) :: t
  def add_artist(%Track{artists: artists} = track, artist) do
    %{track | artists: [artist | artists]}
  end

  @spec add_albumartist(t, artist) :: t
  def add_albumartist(%Track{albumartists: albumartists} = track, artist) do
    %{track | albumartists: [artist | albumartists]}
  end

  @spec set_album(t, album) :: t
  def set_album(%Track{} = track, album) do
    %{track | album: album}
  end

  @spec set_tracknumber(t, tracknumber) :: t
  def set_tracknumber(%Track{} = track, tracknumber) do
    %{track | tracknumber: tracknumber}
  end

  @spec set_date(t, date) :: t
  def set_date(%Track{} = track, date) do
    %{track | date: date}
  end

  @spec set_title(t, title) :: t
  def set_title(%Track{} = track, title) do
    %{track | title: title}
  end

  @spec set_version(t, version) :: t
  def set_version(%Track{} = track, version) do
    %{track | version: version}
  end

  @spec add_performer(t, artist) :: t
  def add_performer(track, artist) do
    %{track | performers: [artist | track.performers]}
  end

  @spec add_copyright(t, copyright) :: t
  def add_copyright(track, copyright) do
    %{track | copyright: [copyright | track.copyright]}
  end

  @spec add_licence(t, licence) :: t
  def add_licence(track, licence) do
    %{track | licence: [licence | track.licence]}
  end

  @spec add_organization(t, organization) :: t
  def add_organization(track, organization) do
    %{track | organizations: [organization | track.organizations]}
  end

  @spec add_description(t, description) :: t
  def add_description(track, description) do
    %{track | description: [description | track.description]}
  end

  @spec add_location(t, location) :: t
  def add_location(track, location) do
    %{track | location: [location | track.location]}
  end

  @spec add_contact(t, contact) :: t
  def add_contact(track, contact) do
    %{track | contacts: [contact | track.contacts]}
  end

  @spec add_isrc(t, isrc) :: t
  def add_isrc(track, isrc) do
    %{track | isrc: [isrc | track.isrc]}
  end

  def add_comment(track, comment) do
    %{track | comments: [comment | track.comments]}
  end


end
