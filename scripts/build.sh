#!/bin/bash
set -e
if [ ! -d /build ]
then
	echo "Please import your module in /build"
	exit 1
fi

if [ ! -d /buildlib ]
then
	echo "Please import a tmp dir in /buildlib"
	exit 1
fi

if [ ! -f /build/dist.ini ]
then
	echo "Nothing to do ..."
	echo "You need to import a dist zilla project"
	exit 0
fi

cp -a /build /tmp
cd /tmp/build

source ~/perl5/perlbrew/etc/bashrc
export PERL_CPANM_OPT="--mirror http://cpan.celogeek.fr --mirror http://cpan.org -l /buildlib"
cpanm -nq Dist::Zilla
cpanm -nq App::local::lib::helper
source /buildlib/bin/localenv-bashrc
dzil authordeps | cpanm -nq
dzil listdeps | cpanm -nq
dzil test

cd /tmp
rm -rf build
rm -rf /home/gitlab_ci_runner/.cpanm
