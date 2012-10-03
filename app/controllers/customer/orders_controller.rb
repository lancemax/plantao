# -*- coding: utf-8 -*-
class Customer::OrdersController < ApplicationController

	before_filter :authenticate_user!

	# POST /orders
	# POST /orders.json
	def create
		@order = Order.new(params[:order])
		@order.user_id = current_user.id

		respond_to do |format|

			if @order.save
				@name='Pedido Realizado com sucesso.'
				#passa o id do pacote para o js
				@save=@order.package_id
				#passa os dados para pagamento
				@num=@order.package.price
				p @num
			else
				@name='Não foi possivel completar sua requisição'
			end
		
			format.js
		end 

	end
end
