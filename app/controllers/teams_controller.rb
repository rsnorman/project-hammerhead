class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]

  # GET /teams or /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    @create_team_command = Commands::CreateTeam.new(team_params)
    @team_create_event = @create_team_command.execute

    respond_to do |format|
      if @team_create_event.valid?
        format.html { redirect_to "/teams/#{@team_create_event.data[:team_id]}", notice: "Team was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    @update_team_command = Commands::UpdateTeam.new(team_params.merge(team: @team))
    @team_update_event = @update_team_command.execute

    respond_to do |format|
      if @team_update_event.valid?
        format.html { redirect_to "/teams/#{@team_update_event.data[:team_id]}", notice: "Team was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @destroy_team_command = Commands::DestroyTeam.new(team: @team)
    @team_destroy_event = @destroy_team_command.execute

    respond_to do |format|
      format.html { redirect_to teams_url, notice: "Team was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name)
    end
end
