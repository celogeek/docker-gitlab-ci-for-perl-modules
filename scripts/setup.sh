#!/bin/bash

chmod +x /build.sh

# Install and hold upgrade
apt-get update
echo udev hold | dpkg --set-selections
echo initscripts hold | dpkg --set-selections
echo upstart hold | dpkg --set-selections
apt-get install -y curl

# Setup repos
echo 'deb http://ftp.fr.debian.org/debian wheezy-backports main' > /etc/apt/sources.list.d/wheezy-backports.sources.list
apt-get update
apt-get upgrade -y
apt-get install -y wget curl gcc libxml2-dev libxslt-dev libcurl4-openssl-dev libreadline6-dev libc6-dev libssl-dev make build-essential zlib1g-dev openssh-server git libyaml-dev libpq-dev libicu-dev
apt-get -t wheezy-backports install -y git

useradd -m -s /bin/bash gitlab_ci_runner

# PERLBREW
su gitlab_ci_runner -c 'curl -L http://install.perlbrew.pl | bash'
echo 'source ~/perl5/perlbrew/etc/bashrc' >> /home/gitlab_ci_runner/.bashrc
echo 'export PERL_CPANM_OPT="--mirror http://cpan.celogeek.com"' >> /home/gitlab_ci_runner/.bashrc
su gitlab_ci_runner -c 'source ~/perl5/perlbrew/etc/bashrc && perlbrew install -j4 -nv --as gitlab_ci_runner-perl-build perl-5.18.1'
su gitlab_ci_runner -c 'source ~/perl5/perlbrew/etc/bashrc && perlbrew switch gitlab_ci_runner-perl-build'
su gitlab_ci_runner -c 'source ~/perl5/perlbrew/etc/bashrc && perlbrew install-cpanm'
su gitlab_ci_runner -c 'source ~/perl5/perlbrew/etc/bashrc && cpanm -nq Dist::Zilla'

