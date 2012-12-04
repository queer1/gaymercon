class ConvertArtistGa < ActiveRecord::Migration
  def up
    execute "update badges set level='artist' where level='artist_ga'"
  end

  def down
    execute "update badges set level='artist_ga' where level='artist'"
  end
end
