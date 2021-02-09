class HomeController < ApplicationController
  def index
    @movies = Movie.includes(:production_company)
                   .order("average_vote DESC")
                   .limit(10)

    @production_companies = ProductionCompany.ordered_by_movies
                                             .limit(10)

    # SELECT COUNT(*) as movie_count, production_companies.name, production_companies.id
    # FROM production_companies
    # JOIN movies ON production_companies.id = movies.production_company_id
    # GROUP BY production_companies.name
    # ORDER BY movie_count DESC;
  end
end
