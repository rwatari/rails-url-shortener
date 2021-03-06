class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true
  validates :long_url, length: { maximum: 1024 }
  validate :recent_submission_count, :premium_user

  def self.random_code
    random_short_url = SecureRandom.urlsafe_base64

    while self.exists?(short_url: random_short_url)
      random_short_url = SecureRandom.urlsafe_base64
    end
    random_short_url
  end

  def self.create_for_user_and_long_url!(user, long_url)
    self.create!(
      user_id: user.id,
      long_url: long_url,
      short_url: self.random_code
    )
  end

  def recent_submission_count
    if ShortenedUrl.where([
      "user_id = ? AND created_at > ?",
      self.user_id,
      1.minute.ago
      ]).count > 5
      errors[:recent_submission_count] << "is too large"
    end
  end

  def premium_user
    user = User.find(self.user_id)
    if !user.premium && user.submitted_urls.count >= 5
      errors[:user] << "is not a premium user"
    end
  end

  # def num_uniques
  #   self.visits.select(:user_id).distinct.count
  # end

  def num_uniques
    self.visitors.count
  end

  def num_clicks
    self.visits.count
  end

  def num_recent_uniques
    self.visits.where(["created_at > ?" , 10.minutes.ago]).count
  end


  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :Visit

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :user

  has_many :taggings,
    primary_key: :id ,
    foreign_key: :url_id ,
    class_name: :Tagging

  has_many :tag_topics,
    through: :taggings,
    source: :tag_topic

end
