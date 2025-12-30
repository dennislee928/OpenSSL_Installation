package OpenSSL::safe::installdata;

use strict;
use warnings;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(
    @PREFIX
    @libdir
    @BINDIR @BINDIR_REL_PREFIX
    @LIBDIR @LIBDIR_REL_PREFIX
    @INCLUDEDIR @INCLUDEDIR_REL_PREFIX
    @APPLINKDIR @APPLINKDIR_REL_PREFIX
    @ENGINESDIR @ENGINESDIR_REL_LIBDIR
    @MODULESDIR @MODULESDIR_REL_LIBDIR
    @PKGCONFIGDIR @PKGCONFIGDIR_REL_LIBDIR
    @CMAKECONFIGDIR @CMAKECONFIGDIR_REL_LIBDIR
    $VERSION @LDLIBS
);

our @PREFIX                     = ( 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0' );
our @libdir                     = ( 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0' );
our @BINDIR                     = ( 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0\apps' );
our @BINDIR_REL_PREFIX          = ( 'apps' );
our @LIBDIR                     = ( 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0' );
our @LIBDIR_REL_PREFIX          = ( '' );
our @INCLUDEDIR                 = ( 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0\include', 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0\include' );
our @INCLUDEDIR_REL_PREFIX      = ( 'include', './include' );
our @APPLINKDIR                 = ( 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0\ms' );
our @APPLINKDIR_REL_PREFIX      = ( 'ms' );
our @ENGINESDIR                 = ( 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0\engines' );
our @ENGINESDIR_REL_LIBDIR      = ( 'engines' );
our @MODULESDIR                 = ( 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0\providers' );
our @MODULESDIR_REL_LIBDIR      = ( 'providers' );
our @PKGCONFIGDIR               = ( 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0' );
our @PKGCONFIGDIR_REL_LIBDIR    = ( '.' );
our @CMAKECONFIGDIR             = ( 'C:\Users\dennis.lee\Downloads\openssl-3.6.0\openssl-3.6.0' );
our @CMAKECONFIGDIR_REL_LIBDIR  = ( '.' );
our $VERSION                    = '3.6.0';
our @LDLIBS                     =
    # Unix and Windows use space separation, VMS uses comma separation
    $^O eq 'VMS'
    ? split(/ *, */, 'ws2_32.lib gdi32.lib advapi32.lib crypt32.lib user32.lib ')
    : split(/ +/, 'ws2_32.lib gdi32.lib advapi32.lib crypt32.lib user32.lib ');

1;
