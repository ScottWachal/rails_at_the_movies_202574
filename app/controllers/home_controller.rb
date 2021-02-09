class HomeController < ApplicationController
  def index
    @movies = Movie.includes(:production_company)
                   .order("average_vote DESC")
                   .limit(10)

    @production_companies = ProductionCompany.select("production_companies.*")
                                             .select("COUNT(production_companies.id) as movie_count")
                                             .joins(:movies)
                                             .group("production_companies.id")
                                             .order("movie_count DESC")
                                             .limit(10)

    # SELECT COUNT(*) as movie_count, production_companies.name, production_companies.id
    # FROM production_companies
    # JOIN movies ON production_companies.id = movies.production_company_id
    # GROUP BY production_companies.name
    # ORDER BY movie_count DESC;
  end
end
