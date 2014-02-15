class Plan < ActiveRecord::Base
  # orendon: comment because it breaks migrations
  # before_validation :set_paymill
  # before_destroy :remove_paymill

  validates :name, uniqueness: true, presence: true
  validates :max_projects, presence: true
  validates :amount, numericality: { greater_than: 1 }

  class << self
    def default
      Plan.find(default_id)
    end

    def default_id
      1
    end
  end

  # TODO: make it work without properly
  # private
  # def set_paymill
  #   if self.paymill_offer_id.blank?
  #     p = Paymill::Offer.create(name: self.name,
  #                               interval: self.interval || "1 month",
  #                               amount: self.amount || 0 ,
  #                               currency: self.currency || "EUR")
  #     self.paymill_offer_id = p.id
  #   else
  #     p = Paymill::Offer.find(self.paymill_offer_id)
  #     p.update_attributes(name: self.name,
  #                         interval: self.interval || "1 month",
  #                         amount: self.amount || 0 ,
  #                         currency: self.currency || "EUR")
  #   end
  # end

  # def remove_paymill
  #   Paymill::Offer.delete(self.paymill_offer_id) unless self.paymill_offer_id.blank?
  # end
end
