module ClinicsHelper


  def active_section(url, section_name)
    
    return "active"
  end
  def print_score_color(score)
    score = score.to_f
    if(score>=90.0)
      return "green_star"
    elsif(score<90.0 && score >=80.0)
      return "blue_star"      
    elsif(score<80.0 && score >=70.0)
      return "yellow_star"      
    else
      return "gray_star"      
    end

  end
  
end
