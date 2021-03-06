require 'rails_helper'

describe 'as an admin' do
  describe 'visiting dashboard page' do
    before(:each) do
      @admin = create(:user, role: 1)
      @order_1 = @admin.orders.create!(id: 1, total: 65, status: 'Paid')
      @order_2 = @admin.orders.create!(id: 2, total: 65, status: 'Ordered')
      @order_3 = @admin.orders.create!(id: 3, total: 65, status: 'Canceled')
      @order_4 = @admin.orders.create!(id: 4, total: 65, status: 'Canceled')
      @order_5 = @admin.orders.create!(id: 5, total: 65, status: 'Ordered')
      @order_6 = @admin.orders.create!(id: 6, total: 65, status: 'Canceled')
    end

    it 'should show all orders' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_dashboard_path

      expect(page).to have_content('All Orders')
      within '#order-1' do
        expect(page).to have_link(@order_1.id)
      end
    end

    it "should show the total number of orders per status" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_dashboard_path

      expect(page).to have_content('Orders by Status')
      expect(page).to have_content("Ordered: 2")
      expect(page).to have_content("Paid: 1")
      expect(page).to have_content("Canceled: 3")
      expect(page).to have_content("Completed: 0")
    end

    it "should filter orders by status" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_dashboard_path

      click_on 'Ordered'

      within '#order-2' do
        expect(page).to have_content(@order_2.id)
        expect(page).to have_content(@order_2.status)
        expect(page).to_not have_content(@order_3.id)
        expect(page).to_not have_content(@order_3.status)

        expect(page).to have_link("Mark as Paid")
        expect(page).to have_link("Cancel Order")
      end
    end

    it "should change status through link" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_dashboard_path

      expect(@order_2.status).to eq('Ordered')

      within '#order-2' do
        click_on 'Mark as Paid'
      end

      expect(page).to have_content('Status: Paid')
    end
  end
end
