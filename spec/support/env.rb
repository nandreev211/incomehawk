if defined?(ActiveRecord::Base)
  begin
    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  rescue LoadError => ignore_if_database_cleaner_not_present
  end
end