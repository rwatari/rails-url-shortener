class Visit < ActiveRecord::Base

  validates :short_url_id,:user_id, presence: true
  
end
