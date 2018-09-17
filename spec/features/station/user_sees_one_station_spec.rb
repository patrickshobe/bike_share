require 'rails_helper'

describe 'registered user sees one station' do
  before(:each) do
    @station_1 = Station.create(name: 'Wash Park East', dock_count: 10, city: 'Denver', installation_date: '2019/08/01')
    @station_2 = Station.create(name: 'Yale St', dock_count: 20, city: 'Englewood', installation_date: '2019/08/01')
    @station_3 = Station.create!(name: 'Broadway', dock_count: 15, city: 'Englewood', installation_date: '2019/08/01')

    @trip_1 = Trip.create!(duration: 100, start_date: '2018/09/01', start_station_id: 1, end_date: '2018/09/01', end_station_id: 2, bike_id: 1, subscription_type: 'cheap', zip_code: 98765)
    @trip_2 = Trip.create!(duration: 120, start_date: '2018/09/01', start_station_id: 2, end_date: '2018/09/01', end_station_id: 1, bike_id: 2, subscription_type: 'expensive', zip_code: 98765)
    @trip_3 = Trip.create!(duration: 80, start_date: '2018/09/02', start_station_id: 1, end_date: '2018/09/02', end_station_id: 2, bike_id: 3, subscription_type: 'expensive', zip_code: 98765)
    @trip_4 = Trip.create!(duration: 140, start_date: '2018/09/02', start_station_id: 2, end_date: '2018/09/02', end_station_id: 1, bike_id: 1, subscription_type: 'cheap', zip_code: 98765)
    @trip_5 = Trip.create!(duration: 60, start_date: '2018/09/03', start_station_id: 1, end_date: '2018/09/03', end_station_id: 2, bike_id: 5, subscription_type: 'expensive', zip_code: 98765)
    @trip_6 = Trip.create!(duration: 160, start_date: '2018/09/03', start_station_id: 2, end_date: '2018/09/03', end_station_id: 1, bike_id: 6, subscription_type: 'cheap', zip_code: 29765)
    @trip_7 = Trip.create!(duration: 160, start_date: '2018/09/04', start_station_id: 1, end_date: '2018/09/04', end_station_id: 2, bike_id: 4, subscription_type: 'cheap', zip_code: 29765)
    @trip_8 = Trip.create!(duration: 80, start_date: '2018/09/05', start_station_id: 3, end_date: '2018/09/05', end_station_id: 3, bike_id: 3, subscription_type: 'expensive', zip_code: 98765)
    @trip_9 = Trip.create!(duration: 140, start_date: '2018/09/06', start_station_id: 3, end_date: '2018/09/06', end_station_id: 3, bike_id: 1, subscription_type: 'cheap', zip_code: 98765)
    @trip_10 = Trip.create!(duration: 60, start_date: '2018/09/06', start_station_id: 3, end_date: '2018/09/06', end_station_id: 3, bike_id: 5, subscription_type: 'expensive', zip_code: 98765)
    @trip_11 = Trip.create!(duration: 160, start_date: '2018/09/06', start_station_id: 1, end_date: '2018/09/06', end_station_id: 3, bike_id: 6, subscription_type: 'cheap', zip_code: 29765)
    @trip_12 = Trip.create!(duration: 160, start_date: '2018/09/06', start_station_id: 1, end_date: '2018/09/06', end_station_id: 3, bike_id: 4, subscription_type: 'cheap', zip_code: 98765)
  end
  
  describe 'they link from stations index' do
    describe 'they see one station' do
      it 'they can not edit or delete station as a regular user' do
        user = create(:user)
        
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        
        visit stations_path

        click_on @station_1.name

        expect(current_path).to eq('/wash-park-east')
        expect(page).to have_content(@station_1.name)
        expect(page).to have_content(@station_1.dock_count)
        expect(page).to have_content(@station_1.city)
        expect(page).to have_content(@station_1.installation_date)
        expect(page).to have_content("Number of rides started at this station: 6")
        expect(page).to have_content("Number of rides ended at this station: 3")
        expect(page).to have_content("Most frequent destination station: #{@station_2.name}")
        expect(page).to have_content("Most frequent origination station: #{@station_2.name}")
        expect(page).to have_content("Date with the highest number of trips started at this station: 2018-09-06")
        expect(page).to have_content("Most frequent zip code for users starting trips at this station: 98765")
        expect(page).to have_content("Bike ID most frequently starting a trip at this station: 4")
        expect(page).to_not have_content('Edit')
        expect(page).to_not have_content('Delete')
      end
    end
  end
  
  describe 'Admin sees one station' do 
    it 'they see link to edit and delete a station' do
      admin = create(:user, role: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit station_path(@station_1)

      expect(current_path).to eq('/wash-park-east')
      expect(page).to have_content(@station_1.name)
      expect(page).to have_content(@station_1.dock_count)
      expect(page).to have_content(@station_1.city)
      expect(page).to have_content(@station_1.installation_date)
      expect(page).to have_content("Number of rides started at this station: 6")
      expect(page).to have_content("Number of rides ended at this station: 3")
      expect(page).to have_content("Most frequent destination station: #{@station_2.name}")
      expect(page).to have_content("Most frequent origination station: #{@station_2.name}")
      expect(page).to have_content("Date with the highest number of trips started at this station: 2018-09-06")
      expect(page).to have_content("Most frequent zip code for users starting trips at this station: 98765")
      expect(page).to have_content("Bike ID most frequently starting a trip at this station: 4")
      expect(page).to have_content('Edit')
      expect(page).to have_content('Delete')
    end 
  end
  
  describe 'As an Admin' do 
    it 'they can link to create a new station from the index page' do 
      admin = create(:user, role: 1)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit station_path(@station_1)
      click_on 'Create A New Station'
      
      expect(current_path).to eq(new_admin_station_path)
    end 
  end
end



