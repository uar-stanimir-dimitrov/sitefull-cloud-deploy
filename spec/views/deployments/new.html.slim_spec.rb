require 'rails_helper'

RSpec.describe 'deployments/new', type: :view do
  let(:template) { stub_model(Template, os: 'debian') }
  let(:deployment) { Deployment.new(provider_type: 'aws', template: template) }
  before do
    assign(:template, template)
    assign(:deployment, deployment)
    assign(:decorator, DeploymentDecorator.new(deployment))
  end

  it 'renders new deployment form' do
    render

    assert_select 'form[action=?][method=?]', template_deployments_path(template), 'post' do
      Deployment::PROVIDERS.each do |provider|
        assert_select "input#deployment_provider_type_#{provider}[name=?]", 'deployment[provider_type]'
      end

      %w(region flavor).each do |type|
        assert_select "select#deployment_#{type}[name=?]", "deployment[#{type}]"
      end
    end
  end
end
