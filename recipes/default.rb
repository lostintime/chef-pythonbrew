#
# Cookbook Name:: pythonbrew
# Recipe:: default
#
# Copyright (c) 2012 lostintimedev.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# install patch dependency
package "patch" do
  action :install
end

pythonbrew_env = {
	'HOME' => "root" == node['pythonbrew']['user'] ? '/root' : node['pythonbrew']['HOME'].to_s.gsub('%user%', node['pythonbrew']['user'])
}

Chef::Log.info("Installing pythonbrew for user '#{node['pythonbrew']['user']}' (#{pythonbrew_env['HOME']})")

execute "install pythonbrew" do
	user node['pythonbrew']['user']
	command "curl -kL http://xrl.us/pythonbrewinstall | bash"
	creates ("root" == node['pythonbrew']['user'] ? node['pythonbrew']['global_path'] : "#{pythonbrew_env['HOME']}/.pythonbrew")
	environment (pythonbrew_env)
end

if "root" != node['pythonbrew']['user']
	# add to bashrc: [[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc
	Chef::Log.info("Setting up ~/.bashrc")

	execute "remove_pythnbrew_bashrc" do
		user node['pythonbrew']['user']
		command "sed -i '/# PYTHONBREW-BEGIN/,/# PYTHONBREW-END>>>/d' $HOME/.bashrc"
		environment (pythonbrew_env)
	end

	execute "add_pythonbrew_bashrc" do
		user node['pythonbrew']['user']
		command "echo '# PYTHONBREW-BEGIN\n[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc\n# PYTHONBREW-END' >> $HOME/.bashrc"
		environment (pythonbrew_env)
	end
end
