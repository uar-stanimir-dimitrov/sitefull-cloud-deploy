require 'rails_helper'

RSpec.describe 'deployments/edit', type: :view do
  let(:template) { stub_model(Template, os: 'debian') }
  before do
    assign(:template, template)
    assign(:deployment, deployment)
    assign(:decorator, DeploymentDecorator.new(deployment))
  end

  # Deployment::PROVIDERS.each do |provider_type|
  [:aws, :google].each do |provider_type|
    let(:deployment) { stub_model(Deployment, provider_type: provider_type, template: template) }
    it 'renders new deployment form' do
      render

      assert_select 'form[action=?][method=?]', template_deployment_path(template, deployment), 'post' do
        Deployment::PROVIDERS.each do |provider|
          if provider == provider_type
            assert_select "input#deployment_provider_type_#{provider}[name=?][checked=checked]", 'deployment[provider_type]'
          else
            assert_select "input#deployment_provider_type_#{provider}[name=?]", 'deployment[provider_type]'
          end
        end

        %w(region flavor).each do |type|
          assert_select "select#deployment_#{type}[name=?]", "deployment[#{type}]"
        end
      end
    end
  end
end