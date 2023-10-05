class SendNotifSlackWhenAddValueJob
  include Sidekiq::Job
  sidekiq_options retry: false

  def perform project_id, month, year
    client = Slack::Web::Client.new

    project = Project.find_by id: project_id
    sum_man_month = project.project_features.filter_month(month)
                           .filter_year(year).sum(:man_month)

    project_slacks = project.project_slack_settings
    project_slacks.each do |project_slack|
      next unless project_slack.send_value?

      mention = convert_to_slack_mention project_slack.slack_mention

      client.chat_postMessage(
        channel: project_slack.slack_room,
        text: message(project.name, mention,
                      month, year,
                      sum_man_month),
        as_user: true
      )
    end
  end

  def message project_name, mention, month, year, sum_man_month
    "#{mention}\n
     #{I18n.t('add_value.message.project_name', locale: :vi)}: #{project_name}\n
     #{I18n.t('add_value.message.date', locale: :vi)}: #{month}/#{year}\n
     #{I18n.t('add_value.message.sum_value', locale: :vi)}: #{sum_man_month}\n"
  end

  def convert_to_slack_mention users
    users = users.split(",").map(&:strip)
    users.map{|user| "<@#{user}>"}.join(" ")
  end
end
