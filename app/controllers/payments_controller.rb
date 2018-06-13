class PaymentsController < ApplicationController
  def index
    @payments = Payment.all
  end
  def create
    item_ids = params[:item_ids]
    if item_ids.nil?
      flash[:danger] = "please select items to payment"
      redirect_to cart_path
    else 
      totals = 0
      item_ids.each do |i|
        item = Item.find(i)
        product = Product.find(item.product_id)
        totals += product.price*item.amounts
      end
      #binding.pry
      @payment = PayPal::SDK::REST::Payment.new({
        intent: "sale",
        ids: "10000",
        payer: {
          payment_method: "paypal" },
        redirect_urls: {
          return_url: success_payments_url,
          cancel_url: root_url },
        transactions: [ {
          :item_ids => item_ids,
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
    binding.pry
    #debugger
    #Order.create(response: JSON(params.slice(:paymentId, :token, :PayerID)))
    if payment.execute( :payer_id => params[:PayerID] )
      
      # Success Message
      # Note that you'll need to `Payment.find` the payment again to access user info like shipping address
    else
      payment.error # Error Hash
    end
    redirect_to root_url, notice: "Payment Succesful"

  end
end