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

::Chef::Recipe.send(:include, Pythonbrew::Helpers)

# install system tools used to setup pythonbrew
%w{patch curl sed}.each do |pkg|
	package pkg do
		action :install
	end
end


_pythonbrew_path = pythonbrew_path(node['pythonbrew']['user'])
_pythonbrew_env = pythonbrew_env(node['pythonbrew']['user'])

Chef::Log.info("Will install pythonbrew to #{_pythonbrew_path} ('#{node['pythonbrew']['user']}')")

execute "install pythonbrew" do
	user node['pythonbrew']['user']
	command "curl -kL http://xrl.us/pythonbrewinstall | bash"
	creates (_pythonbrew_path)
	environment (_pythonbrew_env)
end

if 'root' != node['pythonbrew']['user']
	# add to bashrc: [[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc
	execute "remove_pythnbrew_bashrc" do
		user node['pythonbrew']['user']
		command "sed -i '/# PYTHONBREW-BEGIN/,/# PYTHONBREW-END>>>/d' $HOME/.bashrc"
		environment (_pythonbrew_env)
	end

	execute "add_pythonbrew_bashrc" do
		user node['pythonbrew']['user']
		command "echo '# PYTHONBREW-BEGIN\n[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc\n# PYTHONBREW-END' >> $HOME/.bashrc"
		environment (_pythonbrew_env)
	end
end

