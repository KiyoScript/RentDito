class Dashboard::FaqController < ApplicationController
    before_action :authenticate_user!
end