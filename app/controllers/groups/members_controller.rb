# frozen_string_literal: true

module Groups
  class MembersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_group
    before_action :require_group_admin, except: [:update]

    def index
      @memberships = @group.memberships.eager_load(:user).order(admin: :desc, id: :asc).page(params[:page])
    end

    def update
      if self_leave?
        if @group.admin?(current_user) && @group.only_one_admin?
          redirect_to @group, alert: '唯一の管理者が脱退することはできません'
          return
        end
        @group.withdraw_member current_user
        redirect_to groups_path, notice: "#{@group.name}から脱退しました"
      else
        require_group_admin
        @membership = @group.memberships.find_by!(user_id: params[:id])
        @membership.update!(membership_params)
      end
    end

    private

    def set_group
      @group = current_user.groups.find(params[:group_id])
    end

    def membership_params
      params.require(:membership).permit(:id, :admin, :withdrawal)
    end

    def self_leave?
      current_user.id == params[:id].to_i && membership_params[:withdrawal] == 'true'
    end

    def require_group_admin
      return if @group.admin? current_user

      redirect_back fallback_location: @group, alert: 'この操作を行うには、グループ管理者である必要があります'
    end
  end
end
