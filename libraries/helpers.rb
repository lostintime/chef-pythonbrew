#
# Author:: lostintime <lostintime.dev@gmail.com>
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
#

module Pythonbrew
  module Helpers

    def pythonbrew_fix_version(version)
      m = /^(python[\-\_])?(\d)(\.(\d))?(\.(\d+))?$/i.match(version)
      if m
        "Python-#{m[2]}.#{m[4] ? m[4] : 0}.#{m[6] ? m[6] : 0}"
      else
        nil
      end
    end

    def pythonbrew_is_root(user)
      'root' == user
    end

    def pythonbrew_user_home(user)
      if pythonbrew_is_root(user)
        '/root'
      else
        node['pythonbrew']['HOME'].to_s.gsub('%user%', user)
      end
    end        

    def pythonbrew_env(user)
      {'HOME' => pythonbrew_user_home(user)}
    end

    def pythonbrew_path(user)
      if pythonbrew_is_root(user)
        node['pythonbrew']['global_path']
      else
        pythonbrew_user_home(user) + "/.pythonbrew"
      end
    end

    def pythonbrew_bin(user)
      "#{pythonbrew_path(user)}/bin/pythonbrew"
    end

    def pythonbrew_cmd(user, cmd)
      "#{pythonbrew_bin(user)} #{cmd}"
    end

    def pythonbrew_venv_bin(user)
      "#{pythonbrew_cmd(user, 'venv')}"
    end

    def pythonbrew_venv_cmd(user, cmd)
      "#{pythonbrew_venv_bin(user)} #{cmd}"
    end

    def pythonbrew_pip_bin(user, python_version, venv = nil)
      python_version = pythonbrew_fix_version(python_version)
      cmd = pythonbrew_path(user)

      if venv then
        cmd = cmd + "/venvs/#{python_version}/#{venv}"
      else
        cmd = cmd + "/pythons/#{python_version}"
      end

      cmd + '/bin/pip' 
    end

    def pythonbrew_pip_cmd(cmd, user, python_version, venv = nil)
      pythonbrew_pip_bin(user, python_version, venv) + " #{cmd}"
    end

  end
end
