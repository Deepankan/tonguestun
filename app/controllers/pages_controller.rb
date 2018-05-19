class PagesController < ApplicationController
  def index
    return redirect_to dashboard_path if session['token'].present?
  end

  def sign_up
    return redirect_to dashboard_path if session['token'].present?

    url = ENV['REMOTE_HOST']+'/sign-up'
    body = {
      email: params[:sign_up_email],
      password: params[:sign_up_password],
      confirm_password: params[:sign_up_confirm_password]
    }

    @response = HTTParty.post( url, :body => body )

    if @response['status'] == STATUS_SUCCESS
      session['token'] = @response['token']
      session['user'] = @response['user']
      redirect_to dashboard_path
    else
      redirect_to root_path
    end
  end

  def sign_in
    return redirect_to dashboard_path if session['token'].present?

    url = ENV['REMOTE_HOST']+'/sign-in'
    body = {
      email: params[:email],
      password: params[:password]
    }

    @response = HTTParty.post( url, :body => body )

    if @response['status'] == STATUS_SUCCESS
      session['token'] = @response['token']
      session['user'] = @response['user']
      redirect_to dashboard_path
    else
      redirect_to root_path
    end
  end

  def sign_out
    url = ENV['REMOTE_HOST']+'/sign-out'
    @response = HTTParty.get( url, :headers => { 'Content-Type' => 'application/json', 'Authorization' => "Token token=#{session[:token]}" } )

    if @response['status'] == STATUS_SUCCESS
      session['token'] = nil
      session['user'] = nil
      redirect_to root_path
    else
      redirect_to dashboard_path
    end
  end

  def dashboard
    get_update_list
  end

  def submit_patient
    url = ENV['REMOTE_HOST']+'/create-patient'
    body = {
      name: params[:name],
      phone_number: params[:phone_number]
    }.to_json

    @response = HTTParty.post( url, body: body, headers: { 'Content-Type' => 'application/json', 'Authorization' => "Token token=#{session[:token]}" } )
  end

  def submit_doctor
    url = ENV['REMOTE_HOST']+'/create-doctor'
    body = {
      name: params[:name],
      phone_number: params[:phone_number],
      specialization: params[:specialization]
    }.to_json

    @response = HTTParty.post( url, body: body, headers: { 'Content-Type' => 'application/json', 'Authorization' => "Token token=#{session[:token]}" } )
  end

  def submit_appointment
    url = ENV['REMOTE_HOST']+'/create-appointment'
    body = {
      doctor_id: params[:doctor_id],
      patient_id: params[:patient_id],
      disease: params[:disease]
    }.to_json

    @response = HTTParty.post( url, body: body, headers: { 'Content-Type' => 'application/json', 'Authorization' => "Token token=#{session[:token]}" } )
  end

  private

  def get_update_list
    url = ENV['REMOTE_HOST']+'/get-dashboards'
    @response = HTTParty.get( url, :headers => { 'Content-Type' => 'application/json', 'Authorization' => "Token token=#{session[:token]}" } )

    begin
      if @response['status'] == STATUS_SUCCESS
        @doctors = @response['doctor_lists']
        @patients = @response['patient_lists']
        @appointments = @response['appointments']
      else
        redirect_to root_path
      end
    rescue Exception => e
      redirect_to root_path
    end
  end
end