Name: gtools
Version: 2.0
Release: 6
Summary: Clustering cli tools
Source0: gtools-2.0.tar.gz
License: GPL
Group: Development/Tools 
BuildArch: noarch
BuildRoot: %{_tmppath}/%{name}-buildroot

%description
Beta release of gtools 2.0. Drive Map and Disk Pool tools

%prep
%setup -q

%build

%install
install -m 0775 -d $RPM_BUILD_ROOT/opt/gtools/bin
install -m 0775 dmap $RPM_BUILD_ROOT/opt/gtools/bin/dmap
install -m 0775 loadtest $RPM_BUILD_ROOT/opt/gtools/bin/loadtest
install -m 0775 lsdev $RPM_BUILD_ROOT/opt/gtools/bin/lsdev
install -m 0775 lstemp $RPM_BUILD_ROOT/opt/gtools/bin/lstemp
install -m 0775 lsvdev $RPM_BUILD_ROOT/opt/gtools/bin/lsvdev
install -m 0775 mapASR81605Z $RPM_BUILD_ROOT/opt/gtools/bin/mapASR81605Z
install -m 0775 maplsi $RPM_BUILD_ROOT/opt/gtools/bin/maplsi
install -m 0775 mapr750 $RPM_BUILD_ROOT/opt/gtools/bin/mapr750
install -m 0775 maprr3740 $RPM_BUILD_ROOT/opt/gtools/bin/maprr3740
install -m 0775 wipedev $RPM_BUILD_ROOT/opt/gtools/bin/wipedev
install -m 0775 zcreate $RPM_BUILD_ROOT/opt/gtools/bin/zcreate

install -m 0775 -d ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/dmap ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/loadtest ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/lsdev ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/lstemp ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/lsvdev ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/mapASR81605Z ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/maplsi ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/mapr750 ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/maprr3740 ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/wipedev ${RPM_BUILD_ROOT}%{_bindir}
ln -sf /opt/gtools/bin/zcreate ${RPM_BUILD_ROOT}%{_bindir}

%clean
rm -rf $RPM_BUILD_ROOT

%post
echo . .
echo "All done"

%files
/opt/gtools/bin/dmap
/opt/gtools/bin/loadtest
/opt/gtools/bin/lsdev
/opt/gtools/bin/lstemp
/opt/gtools/bin/lsvdev
/opt/gtools/bin/mapASR81605Z
/opt/gtools/bin/maplsi
/opt/gtools/bin/mapr750
/opt/gtools/bin/maprr3740
/opt/gtools/bin/wipedev
/opt/gtools/bin/zcreate

%{_bindir}/dmap
%{_bindir}/loadtest
%{_bindir}/lsdev
%{_bindir}/lstemp
%{_bindir}/lsvdev
%{_bindir}/mapASR81605Z
%{_bindir}/maplsi
%{_bindir}/mapr750
%{_bindir}/maprr3740
%{_bindir}/wipedev
%{_bindir}/zcreate

%changelog
* Sun Nov 20 2016 BK
- Release 0 Initial Creation

* Sun Nov 20 2016 BK
- Release 1 Testing symlinks

* Sun Nov 20 2016 BK
- Release 2 Added symlinks

* Sun Nov 20 2016 BK
- Release 3 Permissions
 
* Sun Nov 20 2016 BK
- Release 4 Included loadtest and supporting scripts

* Sun Nov 20 2016 BK
- Release 5 Included added lstemp, lsvdev

* Sun Nov 20 2016 BK
- Release 6 Updates
