class GithubWebhooksController < ActionController::API
  include GithubWebhook::Processor

  def up
    render :plain
  end

  # Handle push event
  def github_push(payload)
    # TODO: handle push webhook
  end

  # Handle create event
  def github_create(payload)
    # TODO: handle create webhook
  end

  private

  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end

  def github_workflow_job(payload)
    puts __method__
    write_log(payload)
  end

  def github_workflow_run(payload)
    puts __method__
    write_log(payload)
  end

  def write_log(payload)
    message = [
      "workflow_name: \t #{payload.dig(:workflow_job, :workflow_name)}",
      "action:        \t #{payload.dig(:action)}",
      "name:          \t #{payload.dig(:repository, :name)}",
      "login:         \t #{payload.dig(:sender, :login)}",
      "steps:         \t #{payload.dig(:workflow_job, :steps)}",
      "status:        \t #{payload.dig(:workflow_job, :status)}",
    ].join("\n")

    message = "\n#{message}\n"

    # File.open("messages.txt", "a") do |file|
    #   file.write(message)
    # end

    puts message
    send_to_slack(message)
  end
end

###


# frozen_string_literal: true
require 'slack-ruby-client'

Slack.configure do |config|
  ENV['SLACK_API_TOKEN'] = Rails.application.credentials.slack_token
  config.token = ENV['SLACK_API_TOKEN']
  raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

def send_to_slack(message)
  client = Slack::Web::Client.new
  client.auth_test
  client.chat_postMessage(channel: '#actions-ci', text: message, as_user: true)
end
