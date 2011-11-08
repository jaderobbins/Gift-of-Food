class Admin::VolunteersController < ApplicationController

  http_basic_authenticate_with :name => "frodo", :password => "thering"

  require 'fastercsv'

  def index
    @volunteers = Volunteer.order('last_name DESC').all
    
    respond_to do |format|
      format.html
      format.csv do
        @timestamp = Time.now.strftime('%Y-%m-%d_%H:%M:%S')
        @output_encoding = 'UTF-8'
        @filename = "volunteers_#{@timestamp}.csv"
      end
    end
  end

  def edit
    @volunteer = Volunteer.find(params[:id])
  end

  def update
    @v = Volunteer.find(params[:id])
    @v.neighborhood.team_lead = nil
    @v.neighborhood.save
    @v.update_attributes!(params[:volunteer])
    @v.neighborhood.team_lead = @v
    @v.neighborhood.save
  
    redirect_to admin_volunteers_path
  end

  def destroy
    v = Volunteer.find(params[:id])
    if v.neighborhood.team_lead = v
      v.neighborhood.team_lead = nil
      v.neighborhood.save
    end
    v.delete
    redirect_to admin_volunteers_path
  end

end
