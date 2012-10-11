#!/bin/bash

BUILDDIR=./build
CONTENT=backgrounds\ gnome-background-properties

# Determine architecture
ARCHITECTURE="all"

# Get input
echo "Enter package name:"
read PACKAGENAME
echo "Enter package version:"
read VERSION

PACKAGE="${PACKAGENAME}_${VERSION}_${ARCHITECTURE}"

echo "Creating package called ${PACKAGE}.deb. Is this correct (Y/n)"
read yesno

case $yesno in
    n|N)
        echo "Stopping."
        exit ;;
    *) ;;
esac

# Create builddir
if [ ! -d "$BUILDDIR" ]; then
    mkdir $BUILDDIR
else
    rm -fr $BUILDDIR
    mkdir $BUILDDIR
fi

# Copy files
mkdir -p $BUILDDIR/usr/share/
cp -r $CONTENT $BUILDDIR/usr/share/

# Creating DEBIAN files
echo "Creating control file.."
mkdir -p $BUILDDIR/DEBIAN
cp control $BUILDDIR/DEBIAN/control
sed -i 's/<!-- packagename -->/'$PACKAGENAME'/g' $BUILDDIR/DEBIAN/control
sed -i 's/<!-- version -->/'$VERSION'/g' $BUILDDIR/DEBIAN/control
sed -i 's/<!-- architecture -->/'$ARCHITECTURE'/g' $BUILDDIR/DEBIAN/control

cp postinst $BUILDDIR/DEBIAN/postinst
chmod +x $BUILDDIR/DEBIAN/postinst

# Build package
echo "Building package in ./${PACKAGE}.deb"
if [ -f "./${PACKAGE}.deb" ]
then
  rm -fr "./${PACKAGE}.deb"
fi
fakeroot dpkg-deb --build $BUILDDIR "./${PACKAGE}.deb"


