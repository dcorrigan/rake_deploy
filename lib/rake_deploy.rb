require 'rake'
require 'yaml'
require 'open3'

module RakeDeploy
  def self.load_file(file)
    self.load_yaml(File.read(file))
  end

  def self.load_yaml(string)
    self.load(YAML.load(string))
  end

  def self.load(config)
    Tasks.new(config).install_tasks
  end

  class Tasks
    include Rake::DSL if defined? Rake::DSL
    def initialize(config)
      @config = config
    end

    def install_tasks
      namespace :deploy do
        @config.each do |name, options|
          desc "Deploy #{name}"
          task name do |t, args|
            Rsyncer.new(name, options).rsync
          end
        end
      end
    end
  end

  class Error < ArgumentError; end

  class Rsyncer
    attr_reader :name

    def initialize(name, options)
      @name = name
      @options = options
    end

    def indifferent_hash_access(name)
      @options[name.to_s] || @options[name]
    end

    def self.option_accessor(name)
      define_method name do
        indifferent_hash_access(name) || missing_option(name)
      end
    end
    option_accessor :source
    option_accessor :user
    option_accessor :domain
    option_accessor :target_dir

    def missing_option(name)
      raise Error.new("Missing option #{name}")
    end

    def rsync_options
      indifferent_hash_access(:rsync_options).to_a.join(' ')
    end

    def rsync
      _stdin, @stdout, @stderr, @wait_thr = Open3.popen3(rsync_command)
      write_output
    end

    def write_output
      write_if_exists(@stdout)
      write_if_exists(@stderr)
      puts "Deploying #{name} #{exitstatus}."
    end

    def write_if_exists(io)
      op = io.read
      puts op unless op.empty?
    end

    def exitstatus
      @wait_thr.value.exitstatus == 0 ? 'succeeded' : 'failed'
    end

    def rsync_command
      "rsync -r #{rsync_options} #{source} #{user}@#{domain}:#{target_dir}"
    end
  end
end
