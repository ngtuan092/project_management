class ProjectSlackSetting < ApplicationRecord
  PROJECT_SLACK_SETTING_PARAMS = [
    :project_id, :slack_room, :slack_mention, :send_release,
    :send_value, :send_resource
  ].freeze

  belongs_to :project

  before_save :format_slack_mention

  validate :valid_slack_mention_format

  private
  def format_slack_mention
    # remove trailing space and join with ", "
    self.slack_mention = slack_mention.split(",").map(&:strip).join(", ")
  end

  def valid_slack_mention_format
    mentions = slack_mention.split(",").map(&:strip)
    mentions.each do |mention|
      if mention.blank? || mention.match(Settings.slack_mention.validate)
        errors.add(:slack_mention,
                   I18n.t("project_slack_settings.slack_mention_format"))
      end
    end
  end
end
