class PaymentsController < ApplicationController
  include PaymentHelper
  def index
    @payments = Payment.includes(:items).paginate(page: params[:page], per_page: 5)
  end
  
  def is_items
    item_ids = params[:item_ids]
    if item_ids.blank?
      flash[:danger] = "please select items to payment"
      redirect_to cart_path
    else 
      $items_payment = Item.where(id: item_ids)
      redirect_to new_payment_path
    end
  end

  def new
    @items = $items_payment
    @payment = Payment.new
  end

  def create
    $payment = Payment.new(payment_params)
    if $payment.save
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
          description: "Payment" } ] } )
      if @payment.create
        redirect_url = @payment.links.find {|link| link.rel == 'approval_url'}
        redirect_to redirect_url.href
      else
        $payment.destroy
        redirect_to root_url, notice: @payment.error
      end
    else
      $payment.destroy
      flash[:danger] = "There was something wrong, please fill in all  "
      @payment = $payment
      @items = $items_payment
      render 'new'
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
      $payment.response =  response
      $items_payment.each do |item|
        item.ispayment = true
        item.save
        $payment.items << item
      end
      $payment.save
    else
      $payment.destroy
      payment.error # Error Hash
      flash[:danger] = "There was something wrong"
    end
    redirect_to payment_path($payment)
  end

  def show
    @payment = Payment.find(params[:id])
    @items = @payment.items.includes(:product)
  end

  private

  def payment_params
    params.require(:payment).permit(:name_ship, :phone_ship, :address_ship)
  end
end