module Botylicious
  class Explosm
    include Cinch::Plugin

    match /random c&h/, { method: :fetch_comic }

    def fetch_comic(m)
      image = image_from_page
      m.reply(image)
    end

    private

    def get_page
      Net::HTTP.get(URI("http://explosm.net/comics/#{random_issue}/"))
    end

    def image_from_page(page = get_page)
      html = Nokogiri::HTML.parse(page)
      url = ""
      html.css("#maincontent img").each do |elem|
        url = elem["src"] if elem["src"] =~ /Comics/
      end
      url
    end

    def first_day
      Date.new(2004, 8, 15)
    end

    def newest_issue
      (Date.today - first_day).to_i
    end

    def random_issue
      (1..newest_issue).to_a.sample
    end
  end
end
