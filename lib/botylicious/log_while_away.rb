module Botylicious
  class LogWhileAway
    include Cinch::Plugin
    attr_accessor :files
    UserAwayLog = Struct.new(:user, :file)

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
        lines = []
        file.each_line { |line| lines << line }
        file.close
        paste = Pastie.create(lines.join("\n"))
        User(m.user.nick).send(paste.link)
        File.delete(log)
      end
    end
  end
end
