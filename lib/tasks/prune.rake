namespace :prune do
  desc "Removes non-premium urls over 1 hour old"
  task prune_urls: :environment do
    puts "pruning urls"
    ShortenedUrl.prune
  end
end
