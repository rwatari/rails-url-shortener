namespace :urlshortener do
  desc "Deletes an y shortened url which has not been visited recently"
  task prune: :environment do

    visited_urls = Visit.where(["created_at > ?", 200.minutes.ago]
      ).select(:short_url_id).distinct.map(&:short_url_id)

    urls_to_be_deleted = ShortenedUrl.where("id NOT IN (?)", visited_urls).to_a

    # urls_to_be_deleted.each do |url|
    #   url.destroy
    # end
    urls_to_be_deleted.delete_all
  end
end
