class PaymentsController < ApplicationController
  include PaymentHelper

  def index
    @payments = Payment.paginate(page: params[:page], per_page: 10)
  end
  
  def is_items_to_payment
    items_payment_id = params[:items_payment_id]
    if items_payment_id.blank?
      flash[:danger] = 'Please select items to payment'
      redirect_to select_item_to_payment_path
    else 
      session[:items_payment_id] = []
      session[:items_payment_id] = params[:items_payment_id]
      redirect_to new_payment_path
    end
  end

  def new
    @items = find_items_payment
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    if @payment.save
      session[:payment_id] = @payment.id
      totals = 0
      find_items_payment.each do |item|
        product = item.product
        totals += (product.price)*(item.amounts)
      end
      @payment_paypal = PayPal::SDK::REST::Payment.new({
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
      if @payment_paypal.create
        redirect_url = @payment_paypal.links.find { |link| link.rel == 'approval_url' }
        redirect_to redirect_url.href
      else
        flash[:danger] = @payment_paypal.error
        redirect_to root_url
      end
    else
      flash[:danger] = 'There was something wrong, please fill in all'
      @items = find_items_payment
      render 'new'
    end
  end

  def success
    payment_paypal = PayPal::SDK::REST::Payment.find(params[:paymentId])
    payment = Payment.find(session[:payment_id])
    if payment_paypal.execute( :payer_id => params[:PayerID] )
      flash[:success] = "Successful payment"
      response = { paymentId: params[:paymentId], token: params[:token], PayerID: params[:PayerID] }
      payment.response =  response
      find_items_payment.each do |item|
        item.ispayment = true
        item.save
        payment.items << item
      end
      payment.save
      session[:payment_id] = nil
      redirect_to payment_path(payment)
    else
      payment.destroy
      flash[:danger] = "There was something wrong" + payment_paypal.error
      redirect_to cart_path
    end
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