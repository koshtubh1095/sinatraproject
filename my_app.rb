require 'sinatra/base'
require 'logger'
require 'pry'
require 'will_paginate'
require 'will_paginate/array'
require 'net/http'
set :public_folder, 'public'

class MyApp < Sinatra::Base

  configure do
    register WillPaginate::Sinatra
  end

  hits = Hash.new(0)
  File.open("log/production.log", "r") do |infile|
    while (line = infile.gets)
      match = /(POST|DELETE|PUT|GET) (\S+) (for) (\S+) (at) (\S+)/.match(line)
      if match
        hits[match[1..6]] += 1 if ['asset'].any? { |word| match[2].include?(word) } == false
      end
    end
    get '/my_file.html' do
      @page_title = 'Home'
      @page_id = 'my_file.html'
      page = params.fetch "page", 1
      h = []
      @dates = []
      @arr = []
      hits.each do |a|
        h << a
      end
      @hits = h.paginate(:page => page.to_i, :per_page => 50)
      @hits.each do |d|
        @dates << {
                date: d[0][5],
                total_hits: d[1]
              }
          end
        el = @dates.group_by { |d| d[:date] }
        el.each do |key, value|
          sum = 0
          value.each do |val|
            sum = sum + val[:total_hits]
          end
          @arr << {
            hits: sum.to_s,
            date: key.to_s
          }
        end
      erb :'my_file.html', locals: {hits: @hits, dates: @dates}
    end
  end
end


