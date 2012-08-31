# -*- coding: utf-8 -*-
class Admin::PackagesController < Admin::AdminController
	
	respond_to :html
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

		if params[:package][:price].to_f <= 0.00
				  @name = "O valor não pode ser negativo "
		 			@sucesso = false
					return false
		end


		if params[:package][:price].to_f > 9999.99
			  @name = "O valor não pode ser maior que R$9.999,99 "
	 			@sucesso = false
				return false
		end


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

