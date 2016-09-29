class Vote < ActiveRecord::Base
  validates :user_id, :url_id, presence: true
  validate :no_self_vote
  
  belongs_to :user,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :User

  belongs_to :url,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :ShortenedUrl

    def no_self_vote
      if self.user_id == ShortenedUrl.find(url_id).user_id
        self.errors[:selfo] << "can't like your own url"
      end
    end

end
