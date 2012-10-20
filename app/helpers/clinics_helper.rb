module ClinicsHelper

  def get_award_type(score_type)
    if score_type=="ivf_reports_score"
      return "Overall Award"
    elsif score_type=="safety_score"
      return 'Safety Award'
    elsif score_type=="quality_score"
      return 'Quality Award'
    end
  end
  
  def get_award_icon(score_type)
    if score_type=="ivf_reports_score"
      return "b"
    elsif score_type=="safety_score"
      return 'L'
    elsif score_type=="quality_score"
      return 's'
    end
  end
  
  def get_award_ages(age_group)
    if age_group=="All Ages"
      return "All Ages"
    elsif age_group=="<35"
      return 'Ages Under 35'
    elsif age_group=="35-37"
      return 'Ages 35 - 37'
    elsif age_group=="38-40"
      return 'Ages 38 - 40'
    elsif age_group=="41-42"
      return 'Ages 41 - 42'
    elsif age_group==">42"
      return 'Ages Over 42'
    end
  end
  
  def get_icon_color(rank)
    if rank==1
      return 'gold'
    elsif rank>1 && rank<=5
      return 'silver'
    else
      return 'bronze'
    end
  end

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
