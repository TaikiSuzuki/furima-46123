class ItemsController < ApplicationController
  def index
  end
  
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  
  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :category_id, :condition_id, :shipping_fee_payer_id, :shipping_from_id, :days_to_ship_id, :image).merge(user_id: current_user.id)
  end
end
