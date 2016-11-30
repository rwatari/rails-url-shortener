class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true

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

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User
end
