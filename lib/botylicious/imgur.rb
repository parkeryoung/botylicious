module Botylicious
  class Imgur
    include Cinch::Plugin

    match /imgur tag (.+)/, { method: :fetch_tag }

    def fetch_tag(m, tag)
    end
  end
end
