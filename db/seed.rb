module Seed
end

Dir[File.join(Rails.root, 'db/seed/*.rb')].sort.each { |path| require_relative path }
