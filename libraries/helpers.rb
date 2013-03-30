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

    def pythonbrew_cmd(user)
      "#{pythonbrew_path(user)}/bin/pythonbrew"
    end

    def pythonbrew_venv_cmd(user)
      "#{pythonbrew_cmd(user)} venv"
    end

  end
end
