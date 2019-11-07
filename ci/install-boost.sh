#!/bin/sh
# Assumptions:
# 1) BOOST_ROOT and BOOST_URL are already defined,
# and contain valid values.
# 2) The last namepart of BOOST_ROOT matches the
# folder name internal to boost's .tar.gz
# When testing you can force a boost build by clearing travis caches:
# https://travis-ci.org/ripple/rippled/caches
set -exu

if [ ! -d "$BOOST_ROOT/lib" ]
then
  wget $BOOST_URL -O /tmp/boost.tar.gz
  cd `dirname $BOOST_ROOT`
  rm -fr ${BOOST_ROOT}
  tar xzf /tmp/boost.tar.gz
  cd $BOOST_ROOT
  ./bootstrap.sh
  BLDARGS=()
  BLDARGS+=(--without-python)
  BLDARGS+=(-j$((2*${NUM_PROCESSORS:-2})))
  BLDARGS+=(--prefix=${BOOST_ROOT}/_INSTALLED_)
  #BLDARGS+=(-d0) # suppress messages/output
  BLDARGS+=(cxxflags="-std=c++14")
  BLDARGS+=(runtime-link="static,shared")
  BLDARGS+=(--layout=tagged)
  ./bootstrap.sh
  ./b2 "${BLDARGS[@]}" stage
  ./b2 "${BLDARGS[@]}" install
else
  echo "Using cached boost at $BOOST_ROOT"
fi

