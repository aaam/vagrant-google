def colorize(text, color_code)
  puts "\033[#{color_code}m#{text}\033[0m"
end

{
  :red      => 31,
  :green    => 32,
  :yellow   => 33
}.each do |key, color_code|
  define_method key do |text|
    colorize(text, color_code)
  end
end

namespace :acceptance do

  desc "Run full acceptance suite"
  task :full => [:check_env, :run_full]

  desc "Run smoke tests"
  task :smoke => [:check_env, :run_smoke]

  desc "shows components that can be tested separately"
  task :components do
    exec("bundle exec vagrant-spec components")
  end

  desc "checks if environment variables are set"
  task :check_env do
    yellow "NOTE: For acceptance tests to be functional, correct ssh key needs to be added to GCE metadata."

    if !ENV["GOOGLE_JSON_KEY_LOCATION"] && !ENV["GOOGLE_KEY_LOCATION"]
      abort ("Environment variables GOOGLE_JSON_KEY_LOCATION or GOOGLE_KEY_LOCATION are not set. Aborting.")
    end

    unless ENV["GOOGLE_PROJECT_ID"]
      abort ("Environment variable GOOGLE_PROJECT_ID is not set. Aborting.")
    end

    unless ENV["GOOGLE_CLIENT_EMAIL"]
      abort ("Environment variable GOOGLE_CLIENT_EMAIL is not set. Aborting.")
    end

    unless ENV["GOOGLE_SSH_USER"]
      puts "WARNING: GOOGLE_SSH_USER variable is not set. Will try to start tests using insecure Vagrant private key."
    end
  end

  task :run_full do
    components = %w(
      halt
      multi_instance
      preemptible
      reload
      scopes
      provisioner/shell
      provisioner/chef-solo
    ).map{ |s| "provider/google/#{s}" }

    command = "bundle exec vagrant-spec test --components=#{components.join(" ")}"
    puts command
    puts
    exec(command)
  end

  task :run_smoke do
    components = %w(
      provisioner/shell
    ).map{ |s| "provider/google/#{s}" }

    command = "bundle exec vagrant-spec test --components=#{components.join(" ")}"
    puts command
    puts
    exec(command)
  end
end
