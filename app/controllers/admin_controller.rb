class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_only!
end