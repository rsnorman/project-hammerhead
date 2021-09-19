class CalamitiesController < ApplicationController
  before_action :set_calamity, only: %i[ show edit update destroy ]

  # GET /calamities or /calamities.json
  def index
    @calamities = Calamity.all
  end

  # GET /calamities/1 or /calamities/1.json
  def show
  end

  # GET /calamities/new
  def new
    @calamity = Calamity.new
  end

  # GET /calamities/1/edit
  def edit
  end

  # POST /calamities or /calamities.json
  def create
    @create_calamity_command = Commands::CreateCalamity.new(calamity_params)
    @calamity_create_event = @create_calamity_command.execute

    respond_to do |format|
      if @calamity_create_event.valid?
        format.html { redirect_to "/calamities/#{@calamity_create_event.data[:calamity_id]}", notice: "Calamity was successfully created." }
        format.json { render :show, status: :created, location: @calamity_create_event.data[:calamity_id] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @create_calamity_command.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calamities/1 or /calamities/1.json
  def update
    @update_calamity_command = Commands::UpdateCalamity.new(calamity_params.merge(calamity: @calamity))
    @calamity_update_event = @update_calamity_command.execute

    respond_to do |format|
      if @calamity_update_event.valid?
        format.html { redirect_to "/calamities/#{@calamity_update_event.data[:calamity_id]}", notice: "Calamity was successfully updated." }
        format.json { render :show, status: :ok, location: @calamity_update_event.data[:calamity_id] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @update_calamity_command.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calamities/1 or /calamities/1.json
  def destroy
    @calamity.destroy
    respond_to do |format|
      format.html { redirect_to calamities_url, notice: "Calamity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calamity
      @calamity = Calamity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def calamity_params
      params.require(:calamity).permit(:name, :scheduled_at)
    end
end
