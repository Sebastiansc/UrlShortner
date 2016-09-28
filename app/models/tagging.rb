class Tagging < ActiveRecord::Base
  validates :url_id, :tag_id, presence: true

  belongs_to :tag,
    primary_key: :id,
    foreign_key: :tag_id,
    class_name: :TagTopic

  belongs_to :url,
   primary_key: :id,
   foreign_key: :url_id,
   class_name: :ShortenedUrl
end
