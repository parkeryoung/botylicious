require "botylicious/version"

module Botylicious
  require 'cinch'
  require 'active_support/core_ext/object/try'
  require 'active_support/core_ext/object/blank.rb'
  require 'thor'

  class LogWhileAway
    include Cinch::Plugin
    attr_accessor :files
    UserAwayLog = Struct.new(:user, :file)
    set :prefix, lambda{ |m| Regexp.new("^" + Regexp.escape(m.bot.nick + ": " ))}

    listen_to :leaving, method: :add_log

    listen_to :catchall, method: :log

    match /what did I miss?/, { method: :output_log }

    def add_log(m, user)
      @files ||= []

      unless @files.select { |log| log.user.nick == user.nick }.present?
        Dir.mkdir("logs") unless Dir.exists?("logs")
        @files << log = UserAwayLog.new(user, File.new("logs/#{user.nick}_#{Time.now.to_i}.log", "a"))
        log.file.close
      end
    end

    def log(m)
      if m && m.channel
        (@files || []).each do |away_log|
          unless m.channel.has_user?(away_log.user.nick)
            File.open(away_log.file.to_path, "a") do |new_file|
              new_file << "#{m.user.try(:nick)}: #{m.message}\n"
            end
          end
        end
      end
    end

    def output_log(m)
      m.reply "Just a second #{m.user.nick}"
      logs = Dir["logs/#{m.user.nick}*.log"]
      logs.each do |log|
        file = File.open(log)
        file.each_line { |line| User(m.user.nick).send(line) }
        file.close
        File.delete(log)
      end
    end
  end

  class Botylicious < Thor
    desc "start CHANNEL", "Start bot in CHANNEL"
    def start(chan)
      bot(chan).start
      super
    end

    private

    def bot(chan)
      @bot ||= Cinch::Bot.new do
        configure do |c|
          c.server = "irc.freenode.org"
          c.channels = ["##{chan}"]
          c.nick = "botylicious"
          c.plugins.plugins = [LogWhileAway]
        end
      end
    end
  end
end
