class AttendeesController < ApplicationController
  before_action :set_calamity
  before_action :set_attendee, only: %i[ show edit update destroy ]

  # GET /attendees or /attendees.json
  def index
    @attendees = Attendee.all(calamity_id: @calamity.id)
  end

  # GET /attendees/1 or /attendees/1.json
  def show
  end

  # GET /attendees/new
  def new
    @attendee = Attendee.new(calamity_id: @calamity.id)
  end

  # GET /attendees/1/edit
  def edit
  end

  # POST /attendees or /attendees.json
  def create
    @create_attendee_command = Commands::CreateAttendee.new(attendee_params.merge(calamity_id: @calamity.id))
    @attendee_create_event = @create_attendee_command.execute

    respond_to do |format|
      if @attendee_create_event.valid?
        format.html { redirect_to "/calamities/#{@calamity.id}/attendees/new", notice: "Attendee was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendees/1 or /attendees/1.json
  def update
    @update_attendee_command = Commands::UpdateAttendee.new(attendee_params.merge(attendee: @attendee))
    @attendee_update_event = @update_attendee_command.execute

    respond_to do |format|
      if @attendee_update_event.valid?
        format.html { redirect_to "/calamities/#{@calamity.id}", notice: "Attendee was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendees/1 or /attendees/1.json
  def destroy
    @destroy_attendee_command = Commands::DestroyAttendee.new(attendee: @attendee)
    @attendee_destroy_event = @destroy_attendee_command.execute

    respond_to do |format|
      format.html { redirect_to calamity_attendees_url(@calamity), notice: "Attendee was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calamity
      @calamity = Calamity.find(params[:calamity_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_attendee
      @attendee = Attendee.find(params[:id])

      if @attendee.calamity_id != @calamity.id
        raise ActiveRecord::RecordNotFound
      end
    end

    # Only allow a list of trusted parameters through.
    def attendee_params
      params.require(:attendee).permit(:status)
    end
end
