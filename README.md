make_ssh_config.sh
=======

This scripts generates one ssh_config file from multiple sources. The approach is to make a conf.d for parts of your config and concatenate it together to one file. Please be sure witch files are concatenate! The script uses cutting marks to know where to place the new content.

I use it to separate multiple projects and maintain it individually. Please look at the examples. Tip: Sort your configs by a leading number.

# Requirements

- Bash >= 3 (Tested)

If tested it on all my Mac OS X and Linux systems I have.


# Installation


Just download the `make_ssh_config.sh` script and create your config file. The default config file has to be in the same directory as the script and should be named `config`. Otherwise you can specific one as an argument.

Make the script exacutable:

    chmod +x make_ssh_config.sh

Insert the cutting marks (specified in your config) to your `~/.ssh/config`

# Usage

Just run it:

    ./make_ssh_config.sh

To specific a configuration file:

    ./make_ssh_config.sh path/to/config


# Configuration

Here is a simple example configuration:

```
    SSH_CONFIG="~/.ssh/config"
    SSH_CONFD="~/.ssh/conf.d/"
    START_MARK="### BEGIN GENERATED SSH CONFIG ###"
    END_MARK="### END GENERATED SSH CONFIG ###"

    PRE_HOOK (){
        # Make a backup
        cp $SSH_CONFIG ${SSH_CONFIG}.backup

        # Replace WHOAMI with my current username
        WHOAMI=$(whoami)
        # For Compatibility between OS X (BSD Version) and Linux this workaround
        find $TEMPD -type f -exec sed -i.bak -e "s/WHOAMI/${WHOAMI}/g" {} \;
        find $TEMPD -type f -name "*.bak" -delete
    }
```

The hook is executed before the files are merged together on a temporarily copy of the source files in a temp directory. This is useful if you share your config with your coworkers over an git repository. In the example it replaces 'WHOAMI' with my current username and make a backup of the original file.

Following Options can be written in your config:

* SSH_CONFIG <- the file where the concatenated content will be insert.
* SSH_CONFD <- the directory where the separated config parts are placed
* START_MARK <- the start mark which is searched for
* END_MARK <- the end mark which is searched for
* PRE_HOOK() <- this is a bash function. It is executed (if it exists) before the files are merged together

# Copyright

Copyright 2016 Julian Meyer <jm@julianmeyer.de>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
