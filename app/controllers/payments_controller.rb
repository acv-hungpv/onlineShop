class PaymentsController < ApplicationController
  include PaymentHelper
  before_action :set_payment, only: [:show]
  def index
    @payments = Payment.paginate(page: params[:page], per_page: 20)
  end

  
  def is_items
    item_ids = params[:item_ids]
    if item_ids.blank?
      flash[:danger] = "please select items to payment"
      redirect_to cart_path
    else 
      $items_payment = Item.where(id: item_ids)
      redirect_to ship_infomation_payments_path
    end
  end

  def details 
    @items = $items_payment
  end

  def ship_infomation
    if request.post?
      ship = params[:ship]
      current_user.phone_ship = ship[:phone_ship]
      current_user.address_ship = ship[:address_ship]
      current_user.name_ship = ship[:name_ship]
      if current_user.save
        redirect_to details_payments_path
      else
        flash[:danger] = "There was something wrong"
        redirect_to cart_path
      end
    end
  end

  def create
    totals = 0
    $items_payment.each do |item|
      product = item.product
      totals += (product.price)*(item.amounts)
    end
    @payment = PayPal::SDK::REST::Payment.new({
      intent: "sale",
      payer: {
        payment_method: "paypal" },
      redirect_urls: {
        return_url: success_payments_url,
        cancel_url: root_url },
      transactions: [ {
        amount: {
          total: totals.round(2),
          currency: "USD" },
        description: "ExpressBot Payment" } ] } )
    if @payment.create
      redirect_url = @payment.links.find {|link| link.rel == 'approval_url'}
      redirect_to redirect_url.href
    else
      redirect_to root_url, notice: @payment.error
    end
  end

  # GET /success
  def success
    payment = PayPal::SDK::REST::Payment.find(params[:paymentId])
    if payment.execute( :payer_id => params[:PayerID] )
      flash[:success] = "Successfully payment"
      response = {}
      response[:paymentId] = params[:paymentId]
      response[:token] = params[:token]
      response[:PayerID] = params[:PayerID]
      payment = Payment.create(response: response)
      $items_payment.each do |item|
        item.ispayment = true
        item.save
        payment.items << item
      end
    else
      payment.error # Error Hash
      flash[:danger] = "There was something wrong"
    end
    redirect_to cart_path
  end

  def show

  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end
end