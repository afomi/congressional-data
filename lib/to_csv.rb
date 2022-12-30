require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'
require 'fileutils'
require 'csv'


files = Dir.children("/path/to/congressional_data/117")

CSV.open("../data/csv/congress_117.csv", "wb") do |csv|
  csv << ["id", "firstName", "lastName", "birthDate", "party", "represents", 'profileText']

  files.each do |file|
    string = File.open("/path/to/congressional_data/117/#{file}").read
    json = JSON.parse(string)
    job_positions = json["jobPositions"]
    c = job_positions.collect { |position|
      if position["congressAffiliation"]["congress"] && position["congressAffiliation"]["congress"]["congressNumber"] && position["congressAffiliation"]["congress"]["congressNumber"] == 117
        position["congressAffiliation"]
      end
    }
    c = c.compact

    begin
    csv << [
      json['usCongressBioId'],
      json['givenName'],
      json['familyName'],
      json['birthDate'],
      c.first["partyAffiliation"].first['party']['name'],
      c.first["represents"]['regionCode'],
      json['profileText'],
    ]
    rescue => e
      binding.pry
      puts file.inspect
      puts e.inspect
    end
  end;nil
end

