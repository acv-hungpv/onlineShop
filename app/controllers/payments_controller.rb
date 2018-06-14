class PaymentsController < ApplicationController
  $item_ids = nil

  def index
    @payments = Payment.all
  end

  def create
    $item_ids = params[:item_ids]
    if $item_ids.nil?
      flash[:danger] = "please select items to payment"
      redirect_to cart_path
    else 
      totals = 0
      $item_ids.each do |i|
        item = Item.find(i)
        product = item.product
        totals += (product.price)*(item.amounts)
      end
      #binding.pry
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
  end

  # GET /success
  def success
    payment = PayPal::SDK::REST::Payment.find(params[:paymentId])
    if payment.execute( :payer_id => params[:PayerID] )
      flash[:success] = "successfully payment"
      payment = Payment.create
      $item_ids.each do |i|
        item = Item.find(i)
        item.ispayment = true
        item.save
        payment.items << item
      end
    else
      payment.error # Error Hash
      flash[:danger] = "there was something wrong"
      puts payment.error
      #binding.pry
      puts payment.error
    end
    redirect_to cart_path
  end
end