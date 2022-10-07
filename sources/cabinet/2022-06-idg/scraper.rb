#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    field :name do
      tds.last.text.tidy.delete_prefix('Eng. ')
    end

    field :position do
      "Minister of #{tds.first.text.tidy}"
    end

    private

    def tds
      noko.css('td')
    end
  end

  class Members
    field :members do
      member_container.map { |member| fragment(member => Member).to_h }
    end

    private

    def member_container
      noko.css('.hentry').xpath('.//tr[td]')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
