class SendNotifSlackWhenReleaseJob
  include Sidekiq::Job
  sidekiq_options retry: false

  def perform release_plan_id
    client = Slack::Web::Client.new

    release_plan = ReleasePlan.find_by id: release_plan_id
    project = release_plan.project
    project_slacks = project.project_slack_settings
    project_slacks.each do |project_slack|
      next unless project_slack.send_release?

      mention = convert_to_slack_mention project_slack.slack_mention
      client.chat_postMessage(
        channel: project_slack.slack_room,
        text: message(project.name, mention,
                      release_plan.released_at,
                      release_plan.description),
        as_user: true
      )
    end
  end

  def message project_name, mention, released_at, description
    released_at = released_at.strftime Settings.date.format
    "#{mention}\n
     #{I18n.t('release_plans.message.project_name')}: #{project_name}\n
     #{I18n.t('release_plans.message.actual_release_date')}: #{released_at}\n
     #{I18n.t('release_plans.message.description')}: #{description}"
  end

  def convert_to_slack_mention users
    users = users.split(",").map(&:strip)
    users.map{|user| "<@#{user}>"}.join(" ")
  end
end
