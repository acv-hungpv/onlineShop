class PaymentController < ApplicationController
  def index
    @payments = Payment.all
  end
  def create
    @payment = PayPal::SDK::REST::Payment.new({
      intent: "sale",
      payer: {
        payment_method: "paypal" },
      redirect_urls: {
        return_url: success_orders_url,
        cancel_url: root_url },
      transactions: [ {
        amount: {
          total: "10",
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
    Order.create(response: JSON(params.slice(:paymentId, :token, :PayerID)))
    debugger
    if payment.execute( :payer_id => params[:PayerID] )
      
      # Success Message
      # Note that you'll need to `Payment.find` the payment again to access user info like shipping address
    else
      payment.error # Error Hash
    end
    redirect_to root_url, notice: "Payment Succesful"

  end
end