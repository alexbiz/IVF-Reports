module ReviewsHelper
  def get_star_color(rating, star_order)
    unless rating < star_order
      return 'permyellow'
    end
  end
end
