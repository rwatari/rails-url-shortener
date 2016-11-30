class Visit < ActiveRecord::Base

  validates :short_url_id,:user_id, presence: true

  def self.record_visit!(user, shortened_url)
    self.create!(user_id: user.id, short_url_id: shortened_url.id)
  end

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :short_url,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :ShortenedUrl
end
