class PushTimesController < ApplicationController
  # GET /push_times
  # GET /push_times.json
  def index
    @push_times = PushTime.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @push_times }
    end
  end

  # GET /push_times/1
  # GET /push_times/1.json
  def show
    @push_time = PushTime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @push_time }
    end
  end

  # GET /push_times/new
  # GET /push_times/new.json
  def new
    @push_time = PushTime.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @push_time }
    end
  end

  # GET /push_times/1/edit
  def edit
    @push_time = PushTime.find(params[:id])
  end

  # POST /push_times
  # POST /push_times.json
  def create
    @push_time = PushTime.new(params[:push_time])

    respond_to do |format|
      if @push_time.save
        format.html { redirect_to @push_time, notice: 'Push time was successfully created.' }
        format.json { render json: @push_time, status: :created, location: @push_time }
      else
        format.html { render action: "new" }
        format.json { render json: @push_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /push_times/1
  # PUT /push_times/1.json
  def update
    @push_time = PushTime.find(params[:id])

    respond_to do |format|
      if @push_time.update_attributes(params[:push_time])
        format.html { redirect_to @push_time, notice: 'Push time was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @push_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /push_times/1
  # DELETE /push_times/1.json
  def destroy
    @push_time = PushTime.find(params[:id])
    @push_time.destroy

    respond_to do |format|
      format.html { redirect_to push_times_url }
      format.json { head :no_content }
    end
  end
end
