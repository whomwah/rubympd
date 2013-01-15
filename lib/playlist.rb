class MPD
  # An object representing an .m3u playlist stored by MPD.
  #
  # Playlists are stored inside the configured playlist directory. They are
  # addressed with their file name (without the directory and without the 
  # .m3u suffix).
  #
  # Some of the commands described in this section can be used to run playlist
  # plugins instead of the hard-coded simple m3u parser. They can access
  # playlists in the music directory (relative path including the suffix) or
  # remote playlists (absolute URI with a supported scheme).
  #
  # Changes: rm -> destroy. listplaylistinfo -> songs. Playlist prefixes
  # dropped also of course. Listplaylist not used, kinda inferior to listplaylistinfo
  class Playlist

    attr_accessor :name

    def initialize(mpd, options)
      @name = options[:playlist]
      @mpd = mpd
      #@last_modified = options[:'last-modified']
    end

    # Lists the songs in the playlist. Playlist plugins are supported.
    # @return [Array<MPD::Song>] songs in the playlist.
    def songs
      mpd.build_songs_list @mpd.send_command(:listplaylistinfo, @name)
    end

    # Loads the playlist into the current queue. Playlist plugins are supported.
    #
    # Since 0.17, a range can be passed to load, to load only a part of the playlist.
    # @macro returnraise
    def load(range=nil)
      @mpd.send_command :load, @name, range
    end

    # Adds URI to the playlist.
    # @macro returnraise
    def add(uri)
      @mpd.send_command :playlistadd, @name, uri
    end

    # Clears the playlist.
    # @macro returnraise
    def clear
      @mpd.send_command :playlistclear, @name
    end

    # Deletes song at position POS from the playlist.
    # @macro returnraise
    def delete(pos)
      @mpd.send_command :playlistdelete, @name, pos
    end

    # Moves song with SONGID in the playlist to the position SONGPOS.
    # @macro returnraise
    def move(songid, songpos)
      @mpd.send_command :playlistmove, @name
    end

    # Renames the playlist to +new_name+.
    # @macro returnraise
    def rename(new_name)
      @mpd.send_command :rename, @name, new_name
      @name = new_name
    end

    # Deletes the playlist from the disk.
    # @macro returnraise
    def destroy
      @mpd.send_command :rm, @name
    end

  end
end