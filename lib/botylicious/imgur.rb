module Botylicious
  class Imgur
    include Cinch::Plugin

    match /imgur tag (.*)/, { method: :fetch_tag }

    def fetch_tag(m, tag)
      tag = tag.split(' ').join('+')
      html = Net::HTTP.get URI("http://imgur.com/search?q=#{tag}")
      m.reply 'http:' + Nokogiri::HTML(html).xpath('//img').to_a.sample['src']
    end
  end
end
