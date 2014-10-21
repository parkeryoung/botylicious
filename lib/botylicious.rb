require "botylicious/version"
require 'pry'
module Botylicious
  require 'cinch'
  require 'active_support/core_ext/object/try'
  require 'active_support/core_ext/object/blank.rb'
  require 'thor'
  require 'pastie-api'
  require 'nokogiri'
  require 'botylicious/log_while_away'
  require 'botylicious/help'
  require 'botylicious/threes'
  require 'botylicious/explosm'
  require 'botylicious/imgur'

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
          c.plugins.plugins = [::Botylicious::LogWhileAway, ::Botylicious::Help, ::Botylicious::Threes, ::Botylicious::Explosm, ::Botylicious::Imgur]
          c.plugins.prefix = /^!/
        end
        desc "update", "Will update the repo on the pi and reboot the pi."
        on :message, "update" do |m|
          m.reply "Updating..."
          %x{sudo reboot}
        end
      end
    end
  end
end
