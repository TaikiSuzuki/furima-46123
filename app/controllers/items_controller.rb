class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_sold_or_not_seller, only: [:edit]
  
  def index
    @items = Item.all.order("created_at DESC")
  end
  
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    redirect_to root_path unless @item.user_id == current_user.id
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.user_id == current_user.id
      @item.destroy
    end
    redirect_to root_path
  end

  private

  def set_item
    @item = Item.find_by(id: params[:id])
    redirect_to root_path unless @item
  end

  def redirect_if_sold_or_not_seller
    if @item.order.present? || current_user.id != @item.user_id
      redirect_to root_path
    end
  end

  def item_params
    if params[:item][:image].present?
      params.require(:item).permit(:name, :description, :price, :category_id, :condition_id, :shipping_fee_payer_id, :shipping_from_id, :days_to_ship_id, :image).merge(user_id: current_user.id)
    else
      params.require(:item).permit(:name, :description, :price, :category_id, :condition_id, :shipping_fee_payer_id, :shipping_from_id, :days_to_ship_id).merge(user_id: current_user.id)
    end
  end
end
