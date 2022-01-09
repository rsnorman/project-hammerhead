class TeamMembersController < ApplicationController
  before_action :set_team
  before_action :set_team_member, only: %i[ show edit update destroy ]

  # GET /team_members or /team_members.json
  def index
    @team_members = TeamMember.all(team_id: @team.id)
  end

  # GET /team_members/1 or /team_members/1.json
  def show
  end

  # GET /team_members/new
  def new
    @team_member = TeamMember.new(team_id: @team.id)
  end

  # GET /team_members/1/edit
  def edit
  end

  # POST /team_members or /team_members.json
  def create
    @create_team_member_command = Commands::CreateTeamMember.new(team_member_params.merge(team_id: @team.id))
    @team_member_create_event = @create_team_member_command.execute

    respond_to do |format|
      if @team_member_create_event.valid?
        format.html { redirect_to "/teams/#{@team.id}/team_members/new", notice: "Team Member was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_members/1 or /team_members/1.json
  def update
    @update_team_member_command = Commands::UpdateTeamMember.new(team_member_params.merge(team_member: @team_member))
    @team_member_update_event = @update_team_member_command.execute

    respond_to do |format|
      if @team_member_update_event.valid?
        format.html { redirect_to "/teams/#{@team.id}/team_members/#{@team_member_update_event.data[:team_member_id]}", notice: "Team Member was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_members/1 or /team_members/1.json
  def destroy
    @destroy_team_member_command = Commands::DestroyTeamMember.new(team_member: @team_member)
    @team_member_destroy_event = @destroy_team_member_command.execute

    respond_to do |format|
      format.html { redirect_to team_team_members_url(@team), notice: "Team Member was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:team_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team_member
      @team_member = TeamMember.find(params[:id])

      if @team_member.team_id != @team.id
        raise ActiveRecord::RecordNotFound
      end
    end

    # Only allow a list of trusted parameters through.
    def team_member_params
      params.require(:team_member).permit(:name, :email)
    end
end
