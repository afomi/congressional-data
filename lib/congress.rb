require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'
require 'fileutils'

files = Dir.children("/path/to/BioguideProfiles")

files.each do |file|
  string = File.open(file).read
  json = JSON.parse(string)
  job_positions = json["jobPositions"]
  congressional_terms = job_positions.collect { |position|
    if position["congressAffiliation"]["congress"] && position["congressAffiliation"]["congress"]["congressNumber"]
      position["congressAffiliation"]["congress"]["congressNumber"]
    end
  }
  if congressional_terms.include?(117)
    FileUtils.mv(file, "/path-to-specific-folder/117/")
  end
end
