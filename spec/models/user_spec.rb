# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'name' do
    it '空文字の場合、無効であること' do
      user = described_class.new(name: '', email: 'test@example.com', password: 'password')
      expect(user.valid?).to be(false)
      expect(user.errors[:name]).to include('を入力してください')
    end
  end

  describe '#groups' do
    it '参加しているグループを取得すること' do
      user = described_class.create(name: 'test', email: 'test@example.com', password: 'password')
      active_group = Group.create(name: 'active group')
      active_group.add_member user

      inactive_group = Group.create(name: 'inactive group')
      inactive_group.add_member user
      inactive_group.withdraw_member user

      active_groups = user.groups
      expect(active_groups.size).to eq 1
      expect(active_groups[0].name).to eq active_group.name
    end
  end

  describe '#channels' do
    it '参加しているグループの番組を取得すること' do
      user = described_class.create(name: 'test', email: 'test@example.com', password: 'password')
      active_group = Group.create(name: 'active group')
      active_group.add_member user
      active_group.channels.create(title: 'active channel')

      inactive_group = Group.create(name: 'inactive group')
      inactive_group.add_member user
      inactive_group.withdraw_member user
      inactive_group.channels.create(title: 'inactive channel')

      active_channels = user.channels
      expect(active_channels.size).to eq 1
      expect(active_channels[0].title).to eq 'active channel'
    end
  end
end
