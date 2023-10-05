class SendNotifSlackWhenUpdateResources
  include Sidekiq::Job
  sidekiq_options retry: false

  def perform project_id, month, year
    client = Slack::Web::Client.new

    project = Project.find_by id: project_id
    project_slacks = project.project_slack_settings
    project_slacks.each do |project_slack|
      next unless project_slack.send_resource?

      mention = convert_to_slack_mention project_slack.slack_mention
      client.chat_postMessage(
        channel: project_slack.slack_room,
        text: message(project, mention,
                      month, year),
        as_user: true
      )
    end
  end

  def message project, mention, month, year
    resources_text = ""
    project_user_resources = project.project_user_resources
                                    .filter_month(month)
                                    .filter_year(year)
    project_user_resources.each do |project_user_resource|
      user_name = project_user_resource.user_name
      percentage = project_user_resource.percentage
      resources_text += "#{user_name} ( #{percentage}% )\n"
    end
    <<~TEXT
      #{mention}
      *Đã có cập nhật tài nguyên dự án*
        *Dự án*: #{project.name}
        *Tháng*: #{year}-#{month}
      ```
      #{resources_text}
      ```
    TEXT
  end

  def convert_to_slack_mention users
    users = users.split(",").map(&:strip)
    users.map{|user| "<@#{user}>"}.join(" ")
  end
end
