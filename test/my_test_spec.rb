require 'curl'
require 'rspec'
require 'json'

describe "Splunk Movie list Api test" do
  before(:all) do
    url = "https://splunk.mocklab.io/movies?q=batman"
    curl = Curl::Easy.new(url)
    #curl.http_auth_types = :basic
    curl.headers["Accept"] = "application/json"
    expect(curl.http_get).to be true
    expect(curl.response_code).to eq 200
    @res = JSON.parse(curl.body)

  end

  context "movie titles" do

    it "verifies titles contain batman" do

      #expect((@res["results"]).count).to eq(16)

      titles = @res["results"].map {|t| t['title']}
      titles.each do |t|
        t.include?(name)
      end
      original_titles = @res["results"].map {|t| t['title']}
      original_titles.each do |t|
        t.include?(name)

      end
    end
  end
  context "get other names and count" do
    it "movies list with name Dante" do
      url = "https://splunk.mocklab.io/movies?q=Dante"
      curl = Curl::Easy.new(url)
      curl.headers["Accept"] = "application/json"
      expect(curl.http_get).to be true
      expect(curl.response_code).to eq 200
      @resp = JSON.parse(curl.body)
      if !expect(@resp["results"].first["title"]).to include("Dante")
        expect(@resp["results"].first["original_title"]).to include("Dante")
      end

    end
    it "count parameter" do
      url = "https://splunk.mocklab.io/movies?q=batman&count=3"
      curl = Curl::Easy.new(url)
      curl.headers["Accept"] = "application/json"
      expect(curl.http_get).to be true
      expect(curl.response_code).to eq 200
      @resp = JSON.parse(curl.body)
      expect((@resp["results"]).count).to eq(3)

    end
  end

  #SPL-002: All poster_path links must be valid. poster_path link of null is also acceptable

  context "images and poster path" do
    before(:all) do
      @pp_array = Array.new
      #  pp_array_dup = Array.new
      poster_paths = @res["results"].map {|pp| pp['poster_path']}
      poster_paths.each do |t|
        @pp_array << t

      end
    end
    it "should have valid poster images" do
      expect(@pp_array.empty?).to be_falsey
      expect(t).to start_with("https://www.dropbox.com/s")
      expect(t).to end_with(".jpg?dl=0")

    end
#SPL-001: No two movies should have the same image
#I could use Selenium and get images names and then validate because certain unique urls have same image
    it "No 2 movies should have same poster image" do
      ((expect(@pp_array).to match_array (@pp_array.uniq())) == true)

    end
  end

  # SPL-003: Sorting requirement. Rule #1 Movies with genre_ids == null should be first in response. Rule #2, if multiple movies have genre_ids == null, then sort by id (ascending). For movies that have non-null genre_ids, results should be sorted by id (ascending)
  context "Sorting requirement for genre ids" do
    before(:all) do
      @genre_ids= Array.new

      genre_ids = @res["results"].map {|gi| gi["genre_ids"]}
      genre_ids.each do |g|
        @genre_ids << g

      end
    end
    it " verifies whether contains null" do
      expect(@genre_ids.empty?).to be_falsey
      @res["results"].each  do |gi|
        if gi["genre_ids"]
          puts gi["genre_ids"]

        else
          puts "genre id is nil for movie"
          puts "#{gi["id"]}"
        end
      end

    end
    it "should first display  genre id with null" do
      results_count = @res["results"].count
      genre_id_count = @genre_ids.count
      puts results_count, genre_id_count
      if(results_count > genre_id_count)
        expect(@resp["results"].first["genre_id"]).to eq(nil)
      end
    end
    #SPL-004: The number of movies whose sum of "genre_ids" > 400 should be no more than 7. Another way of saying this is: there at most 7 movies such that their sum of genre_ids is great than 400
    def sum
      inject(0) { |sum, x| sum + x }
    end
    def genre_id_more_than(num)
      count = 0
      genre_ids = @res["results"].map {|gi| gi["genre_ids"]}
      genre_ids.each do |g|
        if g.sum > num
          count = count +1
        end
      end
      return count
    end
    it "verifies movies count with genre_ids > 400" do

      expect(genre_id_more_than(400)).to be <= 7
    end

  end
  #SPL-005: There is at least one movie in the database whose title has a palindrome in it.
  #Example: "title": "Batman: Return of the Kayak Crusaders". The title contains ‘kayak’ which is a palindrome
  def longest_palindrome(string)
    palindromes = []
    for i in 2..string.length-1
      string.chars.each_cons(i).each {|x|palindromes.push(x) if x == x.reverse}
    end
    palindromes.map(&:join).max_by(&:length)
  end
  it "verifies whether title contains palindrome or not" do
    titles = @res["results"].map {|t| t['title']}
    titles.each do |t|
      if longest_palindrome(t)
        puts "title contains palindrome"
        puts t
      end
    end
  end
  #SPL-006: There are at least two movies in the database whose title contain the title of another movie. Example: movie id: 287757 (Scooby-Doo Meets Dante), movie id: 404463 (Dante). This example shows one such set. The business requirement is that there are at least two such occurrences.
  it "verifies titles contains titles of any other movie" do
    titles = @res["results"].map {|t| t['title']}

    titles.each do |t|
      titles.any? { |s| s.include?(t) }
      puts t
      puts "contains in titles of any other movie"
    end
  end
  context " movie title to the movie list" do
    it "should be able to post" do
      url = "https://splunk.mocklab.io/movies?"
      curl = Curl::Easy.new(url)
      #curl.http_auth_types = :basic

      curl.headers["Accept"] = "application/json"
      curl.headers["Content-Type"] = "application/json"
      curl.post_body =  {"name": "Avatar", "description": "Avatar, is a 2009 American[7][8] epic science fiction film directed by James Cameron"}
      expect(curl.http_post).to be true
      expect(curl.response_code).to eq 200
      res = JSON.parse(curl.body)
      puts res
      expect(res["message"]).to eq("Splunking your submission using monkeys ..... success... movie posted to catalog")
    end
      it "posted movie should show in movies list" do
      titles = @res["results"].map {|t| t['title']}
      expect(titles.include?("Avatar Batman")).to be true
        
      end
  end
end
