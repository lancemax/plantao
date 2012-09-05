# -*- coding: utf-8 -*-
class CitiesController < ApplicationController
  
  def load_cities
     
     @cities = City.find_all_by_state_id(params[:state])
      render :inline => "<% if @cities %>  <%= select(:hospital,:city_id,@cities.collect{ |cities| [cities.name,cities.id]}) %> <% end %>"
  end


end
