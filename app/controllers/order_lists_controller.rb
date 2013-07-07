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

  def update
    @order_list = OrderList.find(params[:id])

    respond_to do |format|
      if @order_list.update_attributes(params[:order_list])
        format.json { head :no_content }
      else
        format.json { render json: @order_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end
end
