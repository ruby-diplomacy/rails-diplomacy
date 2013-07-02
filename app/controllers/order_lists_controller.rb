class OrderListsController < ApplicationController
  def index
  end

  def create
    @order_list = OrderList.new(params[:order_list])
   
    respond_to do |format|
      if @order_list.save
        format.json { render json: @order_list, status: :created }
      else
        format.json { render json: @order_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end
end
