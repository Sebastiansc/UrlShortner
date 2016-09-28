class Visit < ActiveRecord::Base
  belongs_to :visitor,
    primary_key: :id,
    foreign_key: :visitor_id,
    class_name: :User

  belongs_to :visited_url,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :ShortenedUrl

  def self.record_visit(user, shortened_url)
    self.create(visitor_id: user.id, url_id: shortened_url.id)
  end
end
