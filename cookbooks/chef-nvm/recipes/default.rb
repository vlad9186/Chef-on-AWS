package "git"
package "tree"
package "curl"
execute "install node" do
user "root"
command `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && export NVM_DIR="$HOME/.nvm" && nvm install node`
end
execute "the folowing" do
user "root"
command "sudo bash /root/.nvm/nvm.sh"
end
execute "the folowing" do
user "root"
command "sudo bash /root/.nvm/bash_completion"
end
git "/usr/local/shop" do
repository "git://github.com/lodka/shop.git"
reference "master"
action :sync
end
execute "install angular cli" do
user "root"
environment ({'PATH' => '/home/ec2-user/.nvm/versions/node/v14.4.0/bin:/usr/local/nvm/v0.10.25/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin'})
cwd "/home/ec2-user/.nvm/versions/node/v14.4.0/lib/"
command "npm install -g @angular/cli@9.0.0 --unsafe-perm=true --allow-root"
end
execute "npm install" do
user "root"
environment ({'PATH' => '/home/ec2-user/.nvm/versions/node/v14.4.0/bin:/usr/local/nvm/v0.10.25/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin'})
cwd "/usr/local/shop"
command "npm i"
end
execute "desable version mismatch" do
user "root"
environment ({'PATH' => '/home/ec2-user/.nvm/versions/node/v14.4.0/bin:/usr/local/nvm/v0.10.25/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin'})
cwd "/usr/local/shop"
command "ng config -g cli.warnings.versionMismatch false"
end
execute "build an app" do
user "root"
environment ({'PATH' => '/home/ec2-user/.nvm/versions/node/v14.4.0/bin:/usr/local/nvm/v0.10.25/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin'})
cwd "/usr/local/shop"
command "ng build "
end
execute "copy dist" do
user "root"
environment ({'PATH' => '/home/ec2-user/.nvm/versions/node/v14.4.0/bin:/usr/local/nvm/v0.10.25/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin'})
command "cp /usr/local/shop/dist/shop/* /usr/share/nginx/html"
end
package "nginx" do
action :install
end
service 'nginx' do
action [ :enable, :start ]
end
template "/etc/nginx/nginx.conf" do
source "nginx.conf.erb"
notifies :reload, "service[nginx]"
end

