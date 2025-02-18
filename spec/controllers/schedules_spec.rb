require "rails_helper"
describe SchedulesController, type: :controller do
  
  describe "Schedules - Actions" do

    let(:room) { Room.create!(
        description: "Room Example", 
        start_time: Time.zone.local(2020,1,1,9,0), 
        end_time: Time.zone.local(2020,1,1,18,0)
      ) 
    }

    let(:schedule) { Schedule.find(1) rescue Schedule.create!(
      room: room,
      subject: "Subject Example",
      start_at: Time.zone.local(2020,1,2,10,0),
      end_at: Time.zone.local(2020,1,2,12,0)
      ) 
    }

    it "GET INDEX and return :ok" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "GET SHOW /schedules/1" do
      get :show, params: {id: schedule.id}
      response_body = JSON.parse(response.body, symbolize_names: true)
      expect(response_body[:id]).to eq(schedule.id) 
    end

    it "POST CREATE and return :created" do
      start_at = Time.zone.local(2022,01,14,10,0)
      end_at = start_at+2.hour
      post :create, params: { schedule: { 
        subject: "Subject", start_at: start_at, end_at: end_at, room_id: room.id } }
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:created)
    end

    it "PATCH UPDATE and return :ok" do
      patch :update, params: { id: schedule.id, schedule: { subject: "Subject Update"} }
      expect(response).to have_http_status(:ok)
    end

    it "PUT UPDATE and return :ok" do
      start_at = Time.zone.local(2022,01,14,10,0)
      end_at = start_at+2.hour
      put :update, params: { id: schedule.id, schedule: { 
        subject: "Schedule Update", start_at: start_at, end_at: end_at, room_id: room.id } }
      expect(response).to have_http_status(:ok)
    end

    it "DELETE DESTROY and return No Content  " do
      put :destroy, params: { id: schedule.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "Schedules - Validations" do
    let(:room) { Room.create!(
        description: "Room Example", 
        start_time: Time.zone.local(2020,1,1,9,0), 
        end_time: Time.zone.local(2020,1,1,18,0)
      ) 
    }

    it "Saturday :unprocessable_entity" do
      start_at = Time.zone.local(2022,01,15,10,0)
      end_at = start_at+2.hour
      
      post :create, params: { schedule: { 
        subject: "Subject", start_at: start_at, end_at: end_at, room_id: room.id } }
      message = JSON.parse(response.body).fetch("base")
      expect(message).to include(/Saturday/)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "Sunday :unprocessable_entity" do
      start_at = Time.zone.local(2022,01,16,10,0)
      end_at = start_at+2.hour
      
      post :create, params: { schedule: { 
        subject: "Subject", start_at: start_at, end_at: end_at, room_id: room.id } }
      message = JSON.parse(response.body).fetch("base")
      expect(message).to include(/Sunday/)
      expect(response).to have_http_status(:unprocessable_entity)
    end

  end
  
end
