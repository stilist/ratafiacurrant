#!/usr/bin/env ruby -wKU
# encoding: UTF-8

# (Ruby 1.8 requires `KU`; 1.9 and forward prefer the magic keyword. See:
#  http://blog.grayproductions.net/articles/ruby_19s_three_default_encodings)

require 'find'

class RCValidate
  @@errors = []

  # http://www.manamplified.org/archives/2006/10/url-regex-pattern.html
  # tags are documented in `rc format.mdown`
  url_pattern = /([A-Za-z][A-Za-z0-9+.-]{1,120}:[A-Za-z0-9\/](([A-Za-z0-9$_.+!*,;\/?:@&~=-])|%[A-Fa-f0-9]{2}){1,333}(#([a-zA-Z0-9][a-zA-Z0-9$_.+!*,;\/?:@&~=%-]{0,1000}))?)/u

  iso_year = /[\+-]?\d{5}/u
  iso_month = /(0[1-9]|1[0-2])/u
  iso_week = /W([0-4][0-9]|5[0-3])/u
  iso_day = /([0-2][0-9]|3[0-1])/u
  iso_weekday = /[1-7]/u
  iso_fraction = /([\.,]\d+)?/u
  iso_hour = /([0-1][0-9]|2[0-4])#{iso_fraction}/u
  iso_minute = /[0-5][0-9]#{iso_fraction}/u
  iso_second = /[0-5][0-9]#{iso_fraction}/u
  iso_timezone = /(Z|[\+-](#{iso_hour}:#{iso_minute}|#{iso_hour}#{iso_minute}|#{iso_hour}))/u
  # xxx does not enforce months' day counts
  iso_cal_date = /#{iso_year}(-#{iso_month}-#{iso_day}|#{iso_month}#{iso_day}|-#{iso_month})/u
  iso_week_date = /#{iso_year}(-#{iso_week}|#{iso_week}|-#{iso_week}-#{iso_weekday}|#{iso_week}#{iso_weekday})/u
  iso_ordinal_date = /#{iso_year}-?([0-2][0-9][0-9]|3([0-5][0-9]|6[0-6]))/u
  iso_time = /(#{iso_hour}:#{iso_minute}(:#{iso_second})?|#{iso_hour}#{iso_minute}(#{iso_second})?|#{iso_hour})/u
  iso_datetime = /#{iso_cal_date}T#{iso_time}/u
  iso_duration = /P((\d+#{iso_fraction}Y)?(#{iso_month}#{iso_fraction}M)?(#{iso_day}#{iso_fraction}D)??(T(#{iso_hour}H)?(#{iso_month}M)?(#{iso_second}S)?)?|\d+#{iso_fraction}W|#{iso_datetime})/u
  iso_interval = /(#{iso_datetime}|#{iso_duration})\/(#{iso_datetime}|#{iso_duration})/u
  iso_repeating_interval = /R(\d+#{iso_fraction})?\/#{iso_interval}/u

  @@valid_metatags = {
      'AUTHOR' => { 'req' => false, 'pat' => /\w+/u },
      'BOOKMARK' => { 'req' => false, 'pat' => url_pattern },
      'COPYRIGHT' => { 'req' => false, 'pat' => /\w+/u },
      'GEOLOCATION' => { 'req' => false, 'pat' => /(ADDR .+|GPS [A-Z0-9-]+ (-)?\d{1,3}(.\d{0,})?, (-)?\d{1,3}(.\d{0,})?)/u },
      'KEYWORDS' => { 'req' => false, 'pat' => /\w+( \w*)*(, \w+( \w+)*)*/u },
      'LICENSE' => { 'req' => false, 'pat' => /\w+/u },
      'LINK' => { 'req' => false, 'pat' => url_pattern },
      'MEDIUM' => { 'req' => false, 'pat' => /.+/u },
      'PERMALINK' => { 'req' => true, 'pat' => url_pattern },
      'PUBLISHED' => { 'req' => true, 'pat' => /(#{iso_datetime}|#{iso_duration})/u },
      'SOURCE' => { 'req' => false, 'pat' => /.+/u },
      'SOURCERANGE' => { 'req' => false, 'pat' => /(p \d+-\d+(, \d+-\d+)*|#{iso_interval}(, #{iso_interval})*)/u },
      'SOURCEURI' => { 'req' => false, 'pat' => url_pattern },
      'TITLE' => { 'req' => true, 'pat' => /.+/u },
      'UPDATED' => { 'req' => true, 'pat' => /(#{iso_datetime}|#{iso_duration})/u }}

  def load_files(paths)
    entry_paths = []
    file_list = []
    paths.each { |p| entry_paths << File.expand_path(p) }

    if entry_paths.empty?
      @@errors << "Please specify a file or directory to validate"
    else
      entry_paths.each { |path|
        Find.find(path) { |f|
          file_list << f
        }
      }
    end

    file_list
  end

  def parse_entry(entry)
    document = entry.split("--\n")
    metatags = document[0]
    body = document[1]
    @@errors << "Couldn't find body section" if body.nil?

    tags = prepare_tags(metatags)
    required_tags?(tags)
    tags.each { |name, data|
      valid_tag?(name, data)
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
        @@errors << "Duplicate metatag: #{tag_name}"
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
        @@errors << "Missing metatag: #{key}"
      end
    }
  end

  def valid_tag?(name, data)
    if @@valid_metatags[name]
      match = (data =~ @@valid_metatags[name]['pat'])
      unless 0 === match
        @@errors << "Invalid metatag data for #{name}: #{data}"
      end
    else
      @@errors << "Invalid metatag: #{name}"
    end
  end

  def valid_body?(body)
  end

  def valid_entry?(paths)
    file_list = load_files(paths.to_a).flatten

    file_list.each { |file|
      if File.file?(file)
        if 0 === (File.extname(file) =~ /\.rc/)
          begin
            entry = IO.read(file)
            parse_entry(entry)
          rescue => err
            @@errors << "Problem reading file: #{err}"
          end
        elsif 0 === (File.extname(file) =~ /\.mdown/)
          @@errors << "#{file} might be valid, but you need to rename it first"
        end

        unless @@errors.empty?
          puts "#{file} failed validation:"
          puts "--"
          @@errors.each { |e| puts e }
          puts "\n\n"
        end

      end
      @@errors = []
    }
  end
end

v = RCValidate.new
v.valid_entry?(ARGV)
