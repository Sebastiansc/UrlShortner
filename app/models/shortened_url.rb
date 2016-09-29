class ShortenedUrl < ActiveRecord::Base
  validates :user_id, :long_url, :short_url, presence: true
  validates :short_url, uniqueness: true
  validates :long_url, length: { maximum: 1023}
  validate :stop_spam
  validate :non_premium_limit
  #validate :valid_user_id?

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor

  has_many :taggings,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Tagging

  has_many :tags,
    through: :taggings,
    source: :tag

  has_many :votes,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Vote

  has_many :voters,
    through: :votes,
    source: :user

  def non_premium_limit
    user = User.find(self.user_id)
    if !user.premium && user.submitted_urls.count >= 5
      self.errors[:not_premium] << 'users can\'t upload more than 5 urls'
    end
  end

  def stop_spam
    recently_submitted = User.find(self.user_id)
                              .submitted_urls
                              .where("created_at >= ?", 1.minute.ago)
                              .count
    if recently_submitted >= 5
      self.errors['spam'] << "Too many recent posts, please wait at least 1 minute"
    end
  end

  def self.prune
    #self.all.where.not(id: num_recent_uniques)
    self.where("id NOT IN (?)", self.recently_used_urls).destroy_all
  end

  def self.recently_used_urls
    self.all.joins(:visits).where("visits.created_at >= ?", 1.hour.ago).ids
  end

  def self.random_code
    begin
      short_url = SecureRandom::urlsafe_base64
    end while self.exists?(short_url)

    short_url
  end

  def self.top
    #we find the sum
    ShortenedUrl.where("id IN (?)", sorted_top).limit(2)
  end

  def self.sorted_top
    ShortenedUrl.joins(:votes).group("votes.url_id")
                .sum(:vote)
                .sort_by { |_,v| -v }
                .map { |k,_| k }
  end

  def self.create_for_user_a_long_url!(user, long_url)
    self.create(user_id: user.id, long_url: long_url, short_url: random_code)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    self.visitors.distinct.count
    # self.visits.select("visitor_id").distinct.count
  end

  def num_recent_uniques
    self.visits.where("created_at >= ?", 1.hour.ago)
  end



end
