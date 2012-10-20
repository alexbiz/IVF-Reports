class Clinic < ActiveRecord::Base
  has_many :datapoints
  has_many :scores
  has_many :reviews
  has_many :requests
  has_many :users
  
  before_save :create_permalink
  
  def awards(year)
    awards = Hash.new
    awards[:count] = 0
    awards[:list] = Array.new
    years = [2005, 2006, 2007, 2008, 2009]
    top_count = 10 #limits the number of clinics to receive an award
	  age_groups = ["All Ages"]
	  diagnoses = ["All Diagnoses"]
	  scores = ['ivf_reports_score', 'quality_score', 'safety_score']
    age_groups.each_with_index do |a, a_index|
	    diagnoses.each_with_index do |d, d_index|
	      scores.each_with_index do |s, s_index|
  	      top_10 = Clinic.joins(:scores).where('scores.year' => year, 'scores.age_group' => age_groups[a_index], 'scores.cycle_type' => 'fresh', 'scores.diagnosis' => diagnoses[d_index]).order("scores.#{scores[s_index]} DESC").limit(top_count)
          top_10_ids = top_10.map{ |clinic| clinic.id }
  	      if top_10_ids.include?(self.id)
  	        awards[:count] += 1
  	        award = Hash.new
  	        award[:age_group] = age_groups[a_index]
  	        award[:year] = year
  	        award[:diagnosis] = diagnoses[d_index]
  	        award[:rank] = top_10_ids.index(self.id) + 1
  	        award[:score] = scores[s_index]
  	        awards[:list] << award
          end
        end
      end
    end
	  age_groups = ["<35","35-37","38-40","41-42",">42"]
	  diagnoses = ["All Diagnoses"]
	  scores = ['ivf_reports_score', 'quality_score', 'safety_score']
    age_groups.each_with_index do |a, a_index|
	    diagnoses.each_with_index do |d, d_index|
	      scores.each_with_index do |s, s_index|
  	      top_10 = Clinic.joins(:scores).where('scores.year' => year, 'scores.age_group' => age_groups[a_index], 'scores.cycle_type' => 'fresh', 'scores.diagnosis' => diagnoses[d_index]).order("scores.#{scores[s_index]} DESC").limit(top_count)
          top_10_ids = top_10.map{ |clinic| clinic.id }
  	      if top_10_ids.include?(self.id)
  	        awards[:count] += 1
  	        award = Hash.new
  	        award[:age_group] = age_groups[a_index]
  	        award[:year] = year
  	        award[:diagnosis] = diagnoses[d_index]
  	        award[:rank] = top_10_ids.index(self.id) + 1
  	        award[:score] = scores[s_index]
  	        awards[:list] << award
          end
        end
      end
    end
	  age_groups = ["All Ages"]
	  diagnoses = ["Endometriosis", "Diminished Ovarian Reserve", "Multiple Female Factors", "Ovulatory Dysfunction", "Tubal Factor", "Female and Male Factors", "Male Factor", "Other Factor", "Unknown Factor", "Uterine Factor"]
	  scores = ['ivf_reports_score', 'quality_score', 'safety_score']
	  age_groups.each_with_index do |a, a_index|
	    diagnoses.each_with_index do |d, d_index|
	      scores.each_with_index do |s, s_index|
  	      top_10 = Clinic.joins(:scores).where('scores.year' => year, 'scores.age_group' => age_groups[a_index], 'scores.cycle_type' => 'fresh', 'scores.diagnosis' => diagnoses[d_index]).order("scores.#{scores[s_index]} DESC").limit(top_count)
          top_10_ids = top_10.map{ |clinic| clinic.id }
  	      if top_10_ids.include?(self.id)
  	        awards[:count] += 1
  	        award = Hash.new
  	        award[:age_group] = age_groups[a_index]
  	        award[:year] = year
  	        award[:diagnosis] = diagnoses[d_index]
  	        award[:rank] = top_10_ids.index(self.id) + 1
  	        award[:score] = scores[s_index]
  	        awards[:list] << award
          end
        end
      end
    end
    return awards
  end
  
  def to_param
    "#{id}-#{clinic_name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end
  
  def self.search(search)
    like_operator = "LIKE"
    if Rails.env.production?
      like_operator = "ILIKE"
    else
      like_operator = "LIKE"
    end
    if search
      state = State.where("name #{like_operator} ?", "%#{search}%")
      if !state.empty?
        Clinic.where("clinic_name #{like_operator} ? OR city #{like_operator} ? OR state #{like_operator} ? OR practice_director #{like_operator} ? OR laboratory_director #{like_operator} ? OR medical_director #{like_operator} ?", "%#{search}%", "%#{search}%", "%#{state.first.abbrev}%", "%#{search}%", "%#{search}%", "%#{search}%").order("clinic_name").all
      else
        Clinic.where("clinic_name #{like_operator} ? OR city #{like_operator} ? OR state #{like_operator} ? OR practice_director #{like_operator} ? OR laboratory_director #{like_operator} ? OR medical_director #{like_operator} ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%").order("clinic_name").all
      end
    else
      Clinic.order("clinic_name").all
    end
  end
  
  private
		def create_permalink
			self.permalink = "#{id}-#{clinic_name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
		end
end
