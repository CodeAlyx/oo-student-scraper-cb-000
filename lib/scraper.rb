require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    hash = Array.new
    doc.css("div.student-card").each do |card|
      hash << {
        name: card.css("h4.student-name").text,
        location: card.css("p.student-location").text,
        profile_url: "./fixtures/student-site/" + card.css("a").attribute("href").value
      }
    end
    hash
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    links = doc.css("div.social-icon-container a")

    hash = {
      profile_quote: doc.css("div.profile-quote").text,
      bio: doc.css("div.bio-content div.description-holder p").text
    }

    links.each do |link|
      if link["href"].include?("twitter")
        hash[:twitter] = link["href"]
      elsif link["href"].include?("linkedin")
        hash[:linkedin] = link["href"]
      elsif link["href"].include?("github")
        hash[:github] = link["href"]
      else
        hash[:blog] = link["href"]
      end
    end
    hash
  end

end

Scraper.scrape_index_page("http://159.203.84.80:30006/fixtures/student-site/")
