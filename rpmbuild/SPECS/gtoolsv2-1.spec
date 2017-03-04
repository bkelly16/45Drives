Name: gtools
Version: 2.1
Release: 2
Summary: Clustering cli tools
Source0: gtools-2.1.tar.gz
License: GPL
Group: Development/Tools 
BuildRoot: %{_tmppath}/%{name}-buildroot

%description
gtools is set of tools used to:
- deploy a glusterFS cluster
- map drives to physical slots
- create ZFS pools
- convenient drive maps (serial,temp,slot #, SMART-STATUS)
- wipe drives

%prep
%setup -q

%build

%install
install -m 0755 -d $RPM_BUILD_ROOT/opt/gtools/bin
install -m 0755 -d $RPM_BUILD_ROOT/etc/gtools
install -m 0755 datagen $RPM_BUILD_ROOT/opt/gtools/bin/datagen
install -m 0755 dmap $RPM_BUILD_ROOT/opt/gtools/bin/dmap
install -m 0755 gcreate $RPM_BUILD_ROOT/opt/gtools/bin/gcreate
install -m 0755 linkedlist $RPM_BUILD_ROOT/opt/gtools/bin/linkedlist
install -m 0755 loadtest $RPM_BUILD_ROOT/opt/gtools/bin/loadtest
install -m 0755 lsdev $RPM_BUILD_ROOT/opt/gtools/bin/lsdev
install -m 0755 lsmodel $RPM_BUILD_ROOT/opt/gtools/bin/lsmodel
install -m 0755 lstemp $RPM_BUILD_ROOT/opt/gtools/bin/lstemp
install -m 0755 lsvdev $RPM_BUILD_ROOT/opt/gtools/bin/lsvdev
install -m 0755 mapadaptec $RPM_BUILD_ROOT/opt/gtools/bin/mapadaptec
install -m 0755 mapSAS2116 $RPM_BUILD_ROOT/opt/gtools/bin/mapSAS2116
install -m 0755 mapSAS3224 $RPM_BUILD_ROOT/opt/gtools/bin/mapSAS3224
install -m 0755 mapr750 $RPM_BUILD_ROOT/opt/gtools/bin/mapr750
install -m 0755 maprr3740 $RPM_BUILD_ROOT/opt/gtools/bin/maprr3740
install -m 0755 mkbrick $RPM_BUILD_ROOT/opt/gtools/bin/mkbrick
install -m 0755 tunepool $RPM_BUILD_ROOT/opt/gtools/bin/tunepool
install -m 0755 wipedev $RPM_BUILD_ROOT/opt/gtools/bin/wipedev
install -m 0755 zcreate $RPM_BUILD_ROOT/opt/gtools/bin/zcreate

install -m 0775 -d ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/dmap ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/gcreate ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/loadtest ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/lsdev ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/mkbrick ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/wipedev ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/zcreate ${RPM_BUILD_ROOT}%{_bindir}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%dir /etc/gtools/
/opt/gtools/bin/datagen
/opt/gtools/bin/gcreate
/opt/gtools/bin/dmap
/opt/gtools/bin/linkedlist
/opt/gtools/bin/loadtest
/opt/gtools/bin/lsdev
/opt/gtools/bin/lstemp
/opt/gtools/bin/lsmodel
/opt/gtools/bin/lsvdev
/opt/gtools/bin/mapadaptec
/opt/gtools/bin/mapSAS2116
/opt/gtools/bin/mapSAS3224
/opt/gtools/bin/mapr750
/opt/gtools/bin/maprr3740
/opt/gtools/bin/mkbrick
/opt/gtools/bin/wipedev
/opt/gtools/bin/tunepool
/opt/gtools/bin/zcreate

%{_bindir}/dmap
%{_bindir}/gcreate
%{_bindir}/loadtest
%{_bindir}/lsdev
%{_bindir}/mkbrick
%{_bindir}/wipedev
%{_bindir}/zcreate

%changelog
* Wed Feb 14 2017 BK
- First release of 2.1

