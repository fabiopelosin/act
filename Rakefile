require 'bundler/gem_tasks'

task :default => :spec

# Bootstrap
#-----------------------------------------------------------------------------#

desc 'Initializes your working copy to run the specs'
task :bootstrap do
  sh "bundle install"
end

# Spec
#-----------------------------------------------------------------------------#

desc 'Run all specs'
task :spec => 'spec:all'

namespace :spec do
  def specs(dir)
    FileList["spec/#{dir}/*_spec.rb"].shuffle.join(' ')
  end

  desc 'Automatically run specs for updated files'
  task :kick do
    exec 'bundle exec kicker -c'
  end

  task :all do
    title 'Running Unit Tests'
    sh "bundle exec bacon #{specs('**')}"

    title 'Checking code style...'
    Rake::Task['rubocop'].invoke
  end
end

# Rubocop
#-----------------------------------------------------------------------------#

desc 'Checks code style'
task :rubocop do
  require 'rubocop'
  cli = Rubocop::CLI.new
  result = cli.run(FileList['lib/**/*.rb'].exclude('lib/cocoapods-core/vendor/**/*').to_a)
  abort('RuboCop failed!') unless result == 0
end

#-----------------------------------------------------------------------------#

def title(title)
  cyan_title = "\033[0;36m#{title}\033[0m"
  puts
  puts '-' * 80
  puts cyan_title
  puts '-' * 80
  puts
end


