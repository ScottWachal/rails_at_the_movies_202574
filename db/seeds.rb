require "csv"

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

    puts "Invalid Movie #{m['original_title']}" unless movie&.valid?
  else
    # error!!
    puts "Invalid Production Company: #{m['production_company']} for movie #{m['original_title']}."
  end
end

puts "Created #{ProductionCompany.count} production companies."
puts "Created #{Movie.count} movies."
