#!/usr/bin/ruby -w

# This code's a mess, but hey--it works.

require 'find'

DEBUG = true

class RC_VALIDATE
  def validate_entry
    entries = File.expand_path(ARGV[0])

    if entries.nil?
      puts "Please specify a file or directory to validate"
    else
      Find.find(entries) { |path|
        if File.file?(path) && (0 === (File.extname(path) =~ /\.rc/))
          begin
            entry = IO.read(path)
            is_invalid = valid_tag?(entry)
            if true === is_invalid
              puts "#{path} failed validation\n\n"
            else
              #puts "#{path} passed validation\n\n" if true === DEBUG
            end
          rescue => err
            puts "Problem reading file: #{err}\n\n"
          end
        elsif File.file?(path) && (0 === (File.extname(path) =~ /\.mdown/))
          puts "#{path} might be valid, but you need to rename it first"
        end
      }
    end
  end

  def valid_tag?(entry)
    is_invalid = false

    # http://www.manamplified.org/archives/2006/10/url-regex-pattern.html
    url_pattern = /([A-Za-z][A-Za-z0-9+.-]{1,120}:[A-Za-z0-9\/](([A-Za-z0-9$_.+!*,;\/?:@&~=-])|%[A-Fa-f0-9]{2}){1,333}(#([a-zA-Z0-9][a-zA-Z0-9$_.+!*,;\/?:@&~=%-]{0,1000}))?)/
    iso_8601_datetime = /[\+-]?\d{5}-(0[1-9]|1[0-2])-([0-2][0-9]|3[0-1])T([0-1][0-9]|2[0-4]):[0-5][0-9]:[0-5][0-9](\.\d+)?(-[0-2]\d{3}|Z)/
    iso_8601_duration = /P(\d+YnMnD)?T\d+H\d+M\d+S\/P(\d+YnMnD)?T\d+H\d+M\d+S/
    valid_metatags = {
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
    required_tags = []
    valid_metatags.each { |key, value|
      required_tags << key if true === value['req']
    }

    # separate entry's metatags from body
    document = entry.split("--\n")
    tag_section = document[0]
    is_invalid = true if document[1].nil?

    if false === is_invalid
      tags = { }
      tag_section.each_line { |t|
        tag = t.split(':')
        tag_name = tag[0]
        # handle cases like URIs where there's more colons; remove leading space
        tag.delete_at(0)
        tag_data = tag.join(':').strip!

        this_tag = { tag_name => tag_data }
        # catch duplicate metatags
        if tags[tag_name]
          puts "Duplicate metatag: #{tag_name}" if true === DEBUG
          is_invalid = true
        else
          tags.merge!(this_tag)
        end
      }
    end

    if false === is_invalid && tags
      required_tags.each { |key, value|
        unless tags[key]
          puts "Missing metatag: #{key}" if true === DEBUG
          is_invalid = true
        end
      }
    else
      is_invalid = true
    end
    
    if false === is_invalid
      tags.each { |name, data|
        if valid_metatags[name]
          match = data =~ valid_metatags[name]['pat']
          unless 0 === match
            puts "Invalid metatag data for #{name}: #{data}" if true === DEBUG
            is_invalid = true
          end
        else
          puts "Invalid metatag: #{name}" if true === DEBUG
          is_invalid = true
        end
      }
    end

    # return document's validity
    is_invalid
  end
end

v = RC_VALIDATE.new
v.validate_entry
