module Botylicious
  class Help
    include Cinch::Plugin

    match /help/, method: :list_help

    def list_help(m)
      unless @bot.paste_url
        messages = @bot.descriptors.map do |descriptor|
          "#{descriptor.usage}: #{descriptor.message}"
        end
        @bot.paste_url = Pastie.create(messages.join("\n")).link
      end
      User(m.user.nick).send(@bot.paste_url)
    end
  end
end

module Cinch
  class Bot < Cinch::User
    attr_accessor :descriptors, :paste_url

    CommandDescriptor = Struct.new(:usage, :message)

    def desc(usage, message)
      @descriptors ||= []
      @descriptors << CommandDescriptor.new(usage, message)
    end

  end
end
