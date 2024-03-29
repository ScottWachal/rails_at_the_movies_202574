require "csv"

MovieGenre.delete_all
Genre.delete_all
Page.delete_all
Movie.delete_all
ProductionCompany.delete_all

# The root path of your rails project is always at: Rails.root
filename = Rails.root.join("db/top_movies.csv")

puts "Loading in Movies from #{filename}."

csv_data = File.read(filename)

movies = CSV.parse(csv_data, headers: true, encoding: "utf-8")

movies.each do |m|
  production_company = ProductionCompany.find_or_create_by(name: m["production_company"])

  if production_company && production_company.valid?
    # build a movie!
    movie = production_company.movies.create(
      title:        m["original_title"],
      year:         m["year"],
      duration:     m["duration"],
      description:  m["description"],
      average_vote: m["avg_vote"]
    )

    unless movie&.valid?
      puts "Invalid Movie #{m['original_title']}"
      next
    end

    genres = m["genre"].split(",").map(&:strip)

    genres.each do |genre_name|
      genre = Genre.find_or_create_by(name: genre_name)
      # this not only adds to the joiner table, but also wires up the FKs back and forth
      MovieGenre.create(movie: movie, genre: genre)
    end
  else
    # error!!
    puts "Invalid Production Company: #{m['production_company']} for movie #{m['original_title']}."
  end
end

Page.create(
  title:     "About Us",
  content:   "We're not really anyone, just a school having fun with IMDB data.",
  permalink: "about_us"
)

Page.create(
  title:     "Data Information",
  content:   "We stole *ahem* borrowed this data from Kraggle.",
  permalink: "data_info"
)

puts "Created #{ProductionCompany.count} production companies."
puts "Created #{Movie.count} Movies."
puts "Created #{Page.count} Pages."
puts "Created #{Genre.count} Genres."
puts "Created #{MovieGenre.count} MovieGenres."
