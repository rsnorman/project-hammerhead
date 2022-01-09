module Commands
  class CreateAttendeeList
    def self.execute(attributes = {})
      new(attributes).execute
    end

    def initialize(attributes = {})
      @calamity_id = attributes[:calamity_id]
      @team_id = attributes[:team_id]
    end

    def execute
      Event.transaction do
        attendee_list_create_event = Event.create!(name: 'AttendeeListCreate', data: {
          calamity_id: @calamity_id,
          team_id: @team_id,
          attendee_list_id: SecureRandom.uuid
        })

        team_members.each do |team_member|
          create_invite(calamity, team_member)
        end

        attendee_list_create_event
      end
    end

    private
      def team
        @team ||= Team.find(@team_id)
      end

      def calamity
        @calamity ||= Calamity.find(@calamity_id)
      end

      def team_members
        @team_members ||= TeamMember.all(team_id: @team_id)
      end

      def create_invite(calamity, team_member)
        Event.create!(name: 'AttendeeCreate', data: {
          calamity_id: calamity.id,
          status: 'pending',
          team_member_id: team_member.id,
          attendee_id: SecureRandom.uuid
        })
      end
  end
end