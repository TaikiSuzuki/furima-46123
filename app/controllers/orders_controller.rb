class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]

  def index
    @order_shipping_form = OrderShippingForm.new
  end

  def create
    @order_shipping_form = OrderShippingForm.new(order_params)
    
    if @order_shipping_form.valid?
      # PAY.JPへの通信
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
            # テスト終わったら解除
      # Payjp::Charge.create(
      #   amount: @item.price,
      #   card: @order_shipping_form.token,
      #   currency: 'jpy'
      # )
      
      # データベースへの保存
      @order_shipping_form.save
      redirect_to root_path, notice: '購入が完了しました'
    else
      render :index
    end
  end

  private
  
  def set_item
    @item = Item.find(params[:item_id])
  end

  def order_params
    params.require(:order_shipping_form).permit(
      :postal_code, :shipping_from_id, :city, :address, :building, :phone_number
    ).merge(
      user_id: current_user.id,
      item_id: @item.id,
      token: params[:token]
    )
  end
end