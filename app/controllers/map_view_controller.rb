class MapViewController < ApplicationController

  def index
    @spatial_features = get_features("natural")
  end

  def select
    @spatial_features = get_features(params[:feature])
    render :index
  end

  def get_features(feature)
    @feature = feature
    db = SQLite3::Database.new("#{Rails.root}/db/map.sqlite3")
    db.enable_load_extension(true)
    db.execute("select load_extension('#{get_extension}');")
    rows = db.execute("select astext(geometry) from pg_#{feature};")
    rows.map{ |x| x.first }
  end

  private 
    def get_extension
      return 'libspatialite.dylib' if (/darwin/ =~ RUBY_PLATFORM) != nil
      return 'libspatialite.so'
    end

end
