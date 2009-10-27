#!/usr/bin/ruby -w

require 'find'

# This code's a mess, but hey--it works.

class RC_VALIDATE
  DEBUG = false
  @@is_invalid = false
  @@errors = []

  # http://www.manamplified.org/archives/2006/10/url-regex-pattern.html
  # tags are documented in `rc format.mdown`
  url_pattern = /([A-Za-z][A-Za-z0-9+.-]{1,120}:[A-Za-z0-9\/](([A-Za-z0-9$_.+!*,;\/?:@&~=-])|%[A-Fa-f0-9]{2}){1,333}(#([a-zA-Z0-9][a-zA-Z0-9$_.+!*,;\/?:@&~=%-]{0,1000}))?)/
  iso_8601_datetime = /[\+-]?\d{5}-(0[1-9]|1[0-2])-([0-2][0-9]|3[0-1])T([0-1][0-9]|2[0-4]):[0-5][0-9]:[0-5][0-9](\.\d+)?(-[0-2]\d{3}|Z)/
  iso_8601_duration = /P(\d+YnMnD)?T\d+H\d+M\d+S\/P(\d+YnMnD)?T\d+H\d+M\d+S/
  @@valid_metatags = {
        'AUTHOR' => {'req' => false, 'pat' => /\w+/},
        'BOOKMARK' => {'req' => false, 'pat' => url_pattern},
        'COPYRIGHT' => {'req' => false, 'pat' => /\w+/},
        'GEOLOCATION' => {'req' => false, 'pat' => /(ADDR .+|GPS [A-Z0-9-]+ (-)?\d{1,3}(.\d{0,})?, (-)?\d{1,3}(.\d{0,})?)/},
        'KEYWORDS' => {'req' => false, 'pat' => /\w+( \w*)*(, \w+( \w+)*)*/},
        'LICENSE' => {'req' => false, 'pat' => /\w+/},
        'LINK' => {'req' => false, 'pat' => url_pattern},
        'MEDIUM' => {'req' => false, 'pat' => /.+/},
        'PERMALINK' => {'req' => true, 'pat' => url_pattern},
        'PUBLISHED' => {'req' => true, 'pat' => iso_8601_datetime},
        'SOURCE' => {'req' => false, 'pat' => /\d{5}(, \w*)?/},
        'SOURCERANGE' => {'req' => false, 'pat' => "(p \d+-\d+(, \d+-\d+)*|#{iso_8601_duration}/#{iso_8601_duration}(, #{iso_8601_duration}/#{iso_8601_duration})*)"},
        'SOURCEURI' => {'req' => false, 'pat' => url_pattern},
        'TITLE' => {'req' => true, 'pat' => /.+/},
        'UPDATED' => {'req' => true, 'pat' => iso_8601_datetime}}

  def load_files(path)
    entries = File.expand_path(path)
    file_list = []

    if entries.nil?
      puts "Please specify a file or directory to validate"
    else
      Find.find(entries) { |f|
        file_list << f
      }
    end

    file_list
  end

  def parse_entry(entry)
    document = entry.split("--\n")
    metatags = document[0]
    body = document[1]

    tags = prepare_tags(metatags)
    tags.each { |name, data|
      bad_tag = valid_tag?(name, data)
    }

    #valid_body?(body)
  end

  def prepare_tags(metatags)
    tags = { }
    metatags.each_line { |t|
      tag = t.split(':')
      tag_name = tag[0]
      # handle tag data with colons
      tag.delete_at(0)
      tag_data = tag.join(':').strip!

      this_tag = { tag_name => tag_data }
      # catch duplicate metatags
      if tags[tag_name]
        @@errors << ["Duplicate metatag: #{tag_name}"]
      else
        tags.merge!(this_tag)
      end
    }

    tags
  end

  def required_tags?(tags)
    required_tags = []
    @@valid_metatags.each { |key, value|
      required_tags << key if true === value['req']
    }
    required_tags.each { |key, value|
      unless tags[key]
        @@errors["Missing metatag: #{key}"]
      end
    }
  end

  def valid_tag?(name, data)
    if @@valid_metatags[name]
      match = data =~ @@valid_metatags[name]['pat']
      unless 0 === match
        @@errors << ["Invalid metatag data for #{name}: #{data}"]
      end
    else
      @@errors << ["Invalid metatag: #{name}"]
    end
  end

  def valid_body?(body)
  end

  def valid_entry?(path)
    file_list = load_files(path)

    file_list.each { |file|
      if File.file?(file)
        if 0 === (File.extname(file) =~ /\.rc/)
          begin
            entry = IO.read(file)
            parse_entry(entry)
          rescue => err
            @@errors << ["Problem reading file: #{err}\n\n"]
          end
        elsif 0 === (File.extname(file) =~ /\.mdown/)
          @@errors << ["#{file} might be valid, but you need to rename it first"]
        end
      end

      unless @@errors.empty?
        puts "#{file} failed validation"
        puts "--"
        @@errors.each { |e| puts e }
        puts "\n\n"
      else
        puts "#{file} passed validation" if DEBUG
      end

      @@errors = []
    }
  end
end

v = RC_VALIDATE.new
# xxx handle any number of arguments
v.valid_entry?(ARGV[0])
