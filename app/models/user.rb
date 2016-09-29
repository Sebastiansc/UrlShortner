class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true


  has_many :submitted_urls,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :ShortenedUrl

  has_many :visits,
    primary_key: :id,
    foreign_key: :visitor_id,
    class_name: :Visit

  has_many :visited_urls,
  through: :visits,
  source: :visited_url

  has_many :votes,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Vote

  has_many :voted_urls,
    through: :votes,
    source: :url

  def record_vote(url, point)
    #find if the user voted for this
    if self.voted_urls.where("shortened_urls.id IN (?)", url.id).exists?
      Vote.find_by(url_id: url.id, user_id: self.id).update(vote: point)
    else
      Vote.create(url_id: url.id, user_id: self.id, vote: point)
    end
  end

  def downvote(url)
    record_vote(url, -1)
  end

  def upvote(url)
    record_vote(url, 1)
  end

  def unvote(url)
    record_vote(url, 0)
  end
end
