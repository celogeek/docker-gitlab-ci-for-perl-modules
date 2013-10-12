#!/bin/bash
set -e
if [ ! -d /build ]
then
	echo "Please import your module in /build"
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
export PERL_CPANM_OPT="--mirror http://cpan.celogeek.fr --mirror http://cpan.org"
cpanm -nq Dist::Zilla
dzil authordeps | cpanm -nq
dzil listdeps | cpanm -nq
dzil test

cd /tmp
rm -rf build
