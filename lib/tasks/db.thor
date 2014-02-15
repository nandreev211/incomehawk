require 'rake'
class Db < Thor

  desc "reset", "[drop, create, migrate, seed] database"
  def reset
    require File.expand_path('config/environment.rb')
    Bacon::Application.load_tasks
    
    puts "Executing: db:drop..."
    Rake::Task[ "db:drop" ].execute
    puts "Executing: db:create..."
    Rake::Task[ "db:create" ].execute
    puts "Executing: db:migrate..."
    Rake::Task[ "db:migrate" ].execute
    puts "Executing: db:seed..."
    Rake::Task[ "db:seed" ].execute
    puts "Executing: admin:add..."
  end  
end