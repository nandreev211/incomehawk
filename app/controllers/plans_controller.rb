class PlansController < ApplicationController
  inherit_resources
  layout 'garden'

  def index
    puts current_user.inspect
  end

  def create
    if params[:todo] == 'upgrade'
      User.transaction do
        begin
          plan = Plan.find_by_name("Unlimited")
          current_user.paymill_client!
          payment = Paymill::Payment.create(token: params[:token], client: current_user.paymill_client_id)
          subs = Paymill::Subscription.create(client: current_user.paymill_client_id, offer: plan.paymill_offer_id, payment: payment.id)
          current_user.paymill_subscription_id = subs.id
          #current_user.organization.plan = plan
          current_user.save!
        rescue StandardError => e
          render :json => {error: e.message}
          return
        end
        render :json => {msg: "card processed, thanks"}
        return
      end
    elsif params[:todo] == 'downgrade'
      unless current_user.paymill_subscription_id.blank?
        Paymill::Subscription.find(current_user.paymill_subscription_id).update_attributes(cancel_at_period_end: true)
        Paymill::Subscription.delete(current_user.paymill_subscription_id)
        render :json => {msg: "Your subscription was cancelled you won't be billed again"}
      end
    end
  end
end
