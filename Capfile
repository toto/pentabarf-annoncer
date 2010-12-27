load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

if ENV['DEPLOY_TO'] == 'bitfever'
  load 'config/deploy-bitfever'
else
  load 'config/deploy'
end
