module Api
  class ContactsController < ApplicationController
    skip_before_action :require_login

    def create
      contact = ContactForm.new(contact_params)
      contact.save!
      head :no_content
    end

    private

    def contact_params
      params.require(:contact).permit(:category, :body)
    end
  end
end
