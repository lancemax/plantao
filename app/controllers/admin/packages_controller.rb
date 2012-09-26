# -*- coding: utf-8 -*-
class Admin::PackagesController < Admin::AdminController
	before_filter :authenticate_user!
	
  	inherit_resources	

	# GET /packages
  	# GET /packages.json
  	def index
    	@packages = Package.all

  	end

	# POST /packages
	# POST /packages.json
	def create
		setMoney(params[:package][:price])

	    @package = Package.new(params[:package])

	    respond_to do |format|
	      if @package.save
	        format.html { redirect_to [:admin,@package], notice: 'Pacote Criado com Sucesso.' }
	        format.json { render json: [:admin,@package], status: :created, location: @package }
	      else
	        format.html { render action: "new" }
	        format.json { render json: @package.errors, status: :unprocessable_entity }
	      end
	    end
	end

end

