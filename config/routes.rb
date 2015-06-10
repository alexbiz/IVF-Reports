IVFReports::Application.routes.draw do
  resources :scores

  resources :users, :except => :index do 
    resources :requests
    resources :subscriptions
  end
  
  resources :patients
  resources :professionals
  resources :admins
  resources :statistics, :only => :index
	resources :sessions, :only => [:new, :create, :destroy]
	
	resources :clinics do
    resources :statistics, :only => [:index]
	  get 'find_clinics_in_state', :on => :collection
	  get 'pull_clinic_data', :on => :collection
	  resources :datapoints
	  resources :requests do 
	    get 'decline', :on => :collection
    end
  end
  
	resources :reviews
	resources :requests, :only => [:test, :create] do
	  get 'test', :on => :collection
  end
  resources :payment_notifications, :only => [:create]
	
	resources :datapoints
	post '/lead-save' => 'pages#lead_save', :as => :lead_save
	get '/register' => 'patients#new'
	get '/signin' => 'sessions#new'
	get '/signout' => 'sessions#destroy'

  root :to => "pages#home"
  get "/complete-contact-form" => "pages#lead_contact", :as => :complete_contact_form
  get "/learn-more" => "pages#lead_registration", :as => :learn_more
  
  get "/find-a-clinic" => "pages#clinicfind", :as => :find_a_clinic
  get "/healthcare-register" => "professionals#new", :as => :healthcare_register
  get "/ranking" => "pages#ranking"
  get "/our-system" => "pages#system", :as => :our_system
  get "/faqs" => "pages#faqs"
  get "/about" => "pages#about"
  get "/contact" => "pages#contact"
  get "/terms-and-conditions" => "pages#terms", :as => :terms_and_conditions
  get "/privacy-policy" => "pages#privacy", :as => :privacy_policy
  get "/clinicians" => "pages#clinicians"
  get "/advertise" => "pages#advertise"
  
  get "/reports/the-ivf-process" => "reports#the_ivf_process", :as => :the_ivf_process
  get "/reports/infertility-diagnoses" => "reports#infertility_diagnoses", :as => :infertility_diagnoses
  get "/reports/cdc-vs-sart" => "reports#cdc_vs_sart", :as => :cdc_vs_sart
  get "/reports/fertility-news" => "reports#fertility_news", :as => :fertility_news
  get "/reports/other-technologies" => "reports#other_technologies", :as => :other_technologies
  get "/reports/clinics-by-region" => "reports#clinics_by_region", :as => :clinics_by_region
  get "/reports/clinic-explorer" => "reports#clinic_explorer", :as => :clinic_explorer
  get "/reports/clinic-comparator" => "reports#clinic_comparator", :as => :clinic_comparator
end