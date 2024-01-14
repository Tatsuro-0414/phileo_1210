class CardsController < ApplicationController
  require "payjp"
  before_action :set_card

  def new      
    card = Card.where(user_id: current_user.id)
    if card.exists?
      redirect_to action: "show"
    else
      card = Card.new(user_id: current_user.id)
    end
  end

  def show
    card = Card.find_by(user_id: current_user.id)
    if card.blank?
      redirect_to action: "new" 
    else
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end

  # def destroy   
    # card = Card.find_by(user_id: current_user.id)
    # binding.pry
    # if card
    #   Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    #   binding.pry
    #   customer = Payjp::Customer.retrieve(user.customer_id)
    #   cus=Payjp::Customer.retrieve(user.customer_id)
    #   cus.delete
    #   binding.pry
    #   redirect_to root_path, notice: 'カード情報を削除しました。'
    # else
    #   redirect_to root_path, alert: 'カード情報が見つかりませんでした。'
    # end
  # end

  def destroy 
    require 'payjp'
    Payjp.api_key = 'sk_test_332f0eea67ba0eadf867b9b8'
    Payjp::Subscription.retrieve(current_user.subscription_id)
     cus = Payjp::Subscription.retrieve(current_user.subscription_id)
     cus.delete
  end

  


  def create
    Payjp.api_key = ENV["SECRET_KEY_ENV"]
    customer = Payjp::Customer.create(
      description: '登録テスト',
      card: params['payjp_token'],
      metadata: {user_id: current_user.id}
    )
  
    current_user.update(customer_id: customer.id)
    current_user.update(subscription_id: subscription.id)
    Payjp::Subscription.create(
      plan: 'getugaku400',
      customer: customer.id
    )
   
  end

  private
  def set_card
    card = Card.where(user_id: current_user.id).first if Card.where(user_id: current_user.id).present?
  end

end
